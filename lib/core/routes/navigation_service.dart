import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool _isPopping = false;

  Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void pop([dynamic value]) {
    return navigatorKey.currentState?.pop(value);
  }

  void goBack() {
    return navigatorKey.currentState?.pop();
  }

  Future<void> safePop() async {
    if (_isPopping) return;

    final navigator = navigatorKey.currentState;
    if (navigator == null || !navigator.canPop()) return;

    _isPopping = true;
    navigator.pop();

    await Future.delayed(const Duration(milliseconds: 200));
    _isPopping = false;
  }

  void popUntil(String desiredRoute) {
    return navigatorKey.currentState!.popUntil((Route<dynamic> route) {
      return route.settings.name == desiredRoute;
    });
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String route,
    bool popToInitial, {
    dynamic arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      route,
      arguments: arguments,
      (Route<dynamic> route) => popToInitial,
    );
  }

  Future<dynamic> pushReplacementNamedWithArgs(
    String desiredRoute, {
    dynamic arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed(
      desiredRoute,
      arguments: arguments,
    );
  }

  Future<dynamic> pushReplacementNamed(
    String desiredRoute, {
    dynamic arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed(
      desiredRoute,
      arguments: arguments,
    );
  }

  NavigatorState? getNavigationState() {
    return navigatorKey.currentState;
  }

  BuildContext getNavigationContext() {
    return navigatorKey.currentState!.context;
  }

  void popDialog(bool value) {
    return navigatorKey.currentState!.pop(value);
  }
}
