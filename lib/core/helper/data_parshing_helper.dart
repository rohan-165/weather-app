import 'package:weather_app/core/services/isolate_service.dart';
import 'package:weather_app/core/utils/debug_log_utils.dart';

final _logger = DebugLoggerService();

/// Safely parses nested data from a response Map
/// [fromJson] : Function to convert a Map into your model T
/// [l]        : Response data (usually decoded JSON)
/// [extraKey] : Optional key to extract nested object from the data
Future<R> mapSucessData<R>({
  required R Function(Map<String, dynamic>) fromJson,
  required dynamic l,
  String? extraKey,
}) async {
  try {
    // Check if input is a Map, else return empty object
    if (l is! Map) {
      _logger.log('$R is not a Map. Returning empty object.');
      return parseObject({}, fromJson);
    }

    dynamic data = l['data']; // Top-level 'data' key

    // Keep unwrapping nested "data" keys until no more
    while (data is Map && data.containsKey('data')) {
      data = data['data'];
    }

    // If data is a Map, decide whether to extract extraKey or parse full Map
    if (data is Map) {
      if (extraKey != null && data.containsKey(extraKey)) {
        final mapData = await IsolateService().mapParsing<R, dynamic>(
          fromJson: fromJson,
          data: data[extraKey],
        );
        return mapData;
      } else {
        final mapData = await IsolateService().mapParsing<R, dynamic>(
          fromJson: fromJson,
          data: data,
        );
        return mapData;
      }
    }

    // If data is not a Map, return empty object
    _logger.log('$R final data is not a Map. Returning empty object.');
    return parseObject({}, fromJson);
  } catch (e, st) {
    // Log exceptions and rethrow to let caller handle if needed
    _logger.log('Exception in $R : $e', level: LogLevel.error);
    _logger.log('StackTrace: $st', level: LogLevel.error);
    rethrow;
  }
}

/// Safely parses a JSON response into a list of model objects.
///
/// This function is designed to handle deeply nested API responses with
/// multiple `"data"` wrappers. It will:
/// - Unwrap nested `"data"` keys until it reaches the actual list.
/// - If [extraKey] is provided, it will attempt to extract the list under that key.
/// - If no valid list is found, it returns an empty list.
/// - Uses [_logger] to track each step and catch exceptions.
Future<List<R>> listSucessData<R>({
  required R Function(Map<String, dynamic>) fromJson,
  required dynamic l,
  String? extraKey,
}) async {
  try {
    // Step 1: Ensure input is a Map
    if (l is! Map) {
      _logger.log('$R: Provided input is not a Map. Returning empty list.');
      return <R>[];
    }

    dynamic data = l['data'];

    // Step 2: Unwrap nested "data" keys
    while (data is Map && data.containsKey('data')) {
      data = data['data'];
    }

    // Step 3: If extraKey is provided, try parsing that
    if (extraKey != null && data is Map && data.containsKey(extraKey)) {
      final listCandidate = data[extraKey];
      if (listCandidate is List) {
        final listData = await IsolateService().listParsing<R, dynamic>(
          fromJson: fromJson,
          data: listCandidate,
        );
        return listData;
      } else {
        _logger.log(
          '$R: extraKey "$extraKey" is not a List. Returning empty list.',
        );
        return <R>[];
      }
    }

    // Step 4: Check if data itself is a List
    if (data is List) {
      final listData = await IsolateService().listParsing<R, dynamic>(
        fromJson: fromJson,
        data: data,
      );
      return listData;
    }

    // Step 5: Fallback case
    _logger.log('$R: No valid list found. Returning empty list.');
    return <R>[];
  } catch (e, st) {
    _logger.log('Exception while parsing $R: $e', level: LogLevel.error);
    _logger.log('StackTrace: $st', level: LogLevel.error);
    rethrow;
  }
}

/// Helper function to safely parse a Map into model T
/// Logs warning if rawMap is not a Map and handles parsing exceptions
T parseObject<T>(dynamic rawMap, T Function(Map<String, dynamic>) fromJson) {
  try {
    if (rawMap is Map<String, dynamic>) {
      return fromJson(rawMap);
    } else {
      _logger.log('$T is not a Map, converting empty Map');
      return fromJson({});
    }
  } catch (e, st) {
    _logger.log('Exception in $T : $e', level: LogLevel.error);
    _logger.log('StackTrace: $st', level: LogLevel.error);
    rethrow;
  }
}

/// Helper function to safely parse a list of JSON objects into a [List<T>].
List<T> parseList<T>(
  dynamic rawList,
  T Function(Map<String, dynamic>) fromJson,
) {
  try {
    if (rawList is! List) return <T>[];
    return rawList
        .whereType<Map<String, dynamic>>() // filter out invalid entries
        .map(fromJson)
        .toList();
  } catch (e, st) {
    _logger.log('Exception in $T : $e', level: LogLevel.error);
    _logger.log('StackTrace: $st', level: LogLevel.error);
    rethrow;
  }
}
