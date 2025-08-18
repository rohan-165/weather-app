import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:weather_app/core/utils/debug_log_utils.dart';

/// Top-level isolate-safe functions
R _parseObject<R>(dynamic rawMap, R Function(Map<String, dynamic>) fromJson) {
  return fromJson(rawMap as Map<String, dynamic>);
}

List<R> _parseList<R>(
  dynamic rawList,
  R Function(Map<String, dynamic>) fromJson,
) {
  final items = rawList as List<dynamic>;
  return items.map((e) => fromJson(e as Map<String, dynamic>)).toList();
}

class IsolateService {
  final DebugLoggerService _logger = DebugLoggerService();
  static final IsolateService _instance = IsolateService._internal();
  factory IsolateService() => _instance;

  IsolateService._internal();

  Isolate? _isolate;
  SendPort? _sendPort;
  final _readyCompleter = Completer<void>();

  final _taskQueue = ListQueue<_QueuedTask<dynamic, dynamic>>();
  bool _isProcessing = false;

  /// Initialize the isolate
  Future<void> init() async {
    if (_isolate != null) {
      _logger.log('Isolate already initialized', level: LogLevel.info);
      return;
    }

    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);

    _sendPort = await receivePort.first as SendPort;
    _readyCompleter.complete();
  }

  /// Entry point for the spawned isolate
  static void _isolateEntry(SendPort sendPort) {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    final logger = DebugLoggerService();
    logger.log(
      'Isolate entry started, listening for tasks...',
      level: LogLevel.info,
    );

    port.listen((message) {
      if (message is _IsolateTask) {
        try {
          logger.log('Executing task inside isolate...', level: LogLevel.info);
          final result = message.task(message.param);
          message.replyTo.send(result);
          logger.log('Task executed successfully ✅', level: LogLevel.success);
        } catch (e, st) {
          message.replyTo.send(Future.error(e, st));
          logger.log('Task failed ❌ : $e', level: LogLevel.error);
        }
      }
    });
  }

  /// Generic run for any heavy computation
  Future<R> run<R, P>(R Function(P param) task, P param) async {
    await _readyCompleter.future;

    final completer = Completer<R>();
    _taskQueue.add(_QueuedTask<R, P>(task, param, completer));
    _logger.log(
      'Task queued. Queue length: ${_taskQueue.length}',
      level: LogLevel.info,
    );

    if (!_isProcessing) {
      _logger.log('Starting queue processing...', level: LogLevel.info);
      _processQueue();
    }

    return completer.future;
  }

  /// Parse a single object using model fromJson
  Future<R> mapParsing<R, P>({
    required R Function(Map<String, dynamic>) fromJson,
    required P data,
  }) async {
    return run<R, P>((raw) => _parseObject<R>(raw, fromJson), data);
  }

  /// Parse a list of objects using model fromJson
  Future<List<R>> listParsing<R, P>({
    required R Function(Map<String, dynamic>) fromJson,
    required P data,
  }) async {
    return run<List<R>, P>((raw) => _parseList<R>(raw, fromJson), data);
  }

  /// Process the queue sequentially
  void _processQueue() async {
    if (_taskQueue.isEmpty) {
      _isProcessing = false;
      _logger.log('Queue empty, stopping processing.', level: LogLevel.info);
      return;
    }

    _isProcessing = true;
    final currentTask = _taskQueue.removeFirst();
    final responsePort = ReceivePort();

    _logger.log('Sending task to isolate...', level: LogLevel.info);
    _sendPort?.send(
      _IsolateTask(currentTask.param, currentTask.task, responsePort.sendPort),
    );

    try {
      final result = await responsePort.first;
      currentTask.completer.complete(result as dynamic);
      _logger.log('Task completed successfully ✅', level: LogLevel.success);
    } catch (e, st) {
      currentTask.completer.completeError(e, st);
      _logger.log('Task failed ❌: $e', level: LogLevel.error);
    } finally {
      responsePort.close();
      _processQueue(); // process next task
    }
  }

  /// Dispose the isolate
  void dispose() {
    if (_isolate != null) {
      _logger.log('Disposing IsolateService...', level: LogLevel.warning);
      _isolate?.kill(priority: Isolate.immediate);
      _isolate = null;
      _sendPort = null;
      _isProcessing = false;
      _taskQueue.clear();
      _logger.log('Isolate disposed successfully 🛑', level: LogLevel.success);
    } else {
      _logger.log(
        'Dispose called, but isolate already null',
        level: LogLevel.warning,
      );
    }
  }
}

class _IsolateTask<R, P> {
  final P param;
  final R Function(P) task;
  final SendPort replyTo;
  _IsolateTask(this.param, this.task, this.replyTo);
}

class _QueuedTask<R, P> {
  final R Function(P) task;
  final P param;
  final Completer<R> completer;
  _QueuedTask(this.task, this.param, this.completer);
}
