// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/core/utils/app_toast.dart';

typedef PopInvokedWithResultCallback<T> = void Function(bool didPop, T? result);

class AppExit<T> extends StatefulWidget {
  const AppExit({
    super.key,
    required this.child,
    this.onPopInvokedWithResult,
    this.canPop = true,
  });

  final Widget child;
  final PopInvokedWithResultCallback<T>? onPopInvokedWithResult;
  final bool canPop;

  @override
  _AppExitState<T> createState() => _AppExitState<T>();

  static _AppExitState<T>? of<T>(BuildContext context) {
    return context.findAncestorStateOfType<_AppExitState<T>>();
  }
}

class _AppExitState<T> extends State<AppExit<T>> implements PopEntry<T> {
  ModalRoute<dynamic>? _route;
  @override
  late final ValueNotifier<bool> canPopNotifier;

  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    canPopNotifier = ValueNotifier<bool>(widget.canPop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute<dynamic>? newRoute = ModalRoute.of(context);
    if (newRoute != _route) {
      _route?.unregisterPopEntry(this);
      _route = newRoute;
      _route?.registerPopEntry(this);
    }
  }

  @override
  void didUpdateWidget(covariant AppExit<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    canPopNotifier.value = widget.canPop;
  }

  @override
  void dispose() {
    _route?.unregisterPopEntry(this);
    canPopNotifier.dispose();
    super.dispose();
  }

  @override
  void onPopInvoked(bool didPop) {
    // Optional
  }

  @override
  void onPopInvokedWithResult(bool didPop, T? result) {
    if (widget.onPopInvokedWithResult != null) {
      widget.onPopInvokedWithResult!(didPop, result);
    } else {
      final DateTime now = DateTime.now();
      if (_lastBackPressTime == null ||
          now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
        _lastBackPressTime = now;
        AppToasts().showToast(
          message: "Tap back again to exit app.",
          backgroundColor: Colors.black,
        );
      } else {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
