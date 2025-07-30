import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/constants/shared_pref_keys.dart';
import 'package:weather_app/core/routes/navigation_service.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/services/local_storage/shared_pref_service.dart';

@lazySingleton
class ThemeCubit extends Cubit<String> {
  ThemeCubit() : super(ThemeMode.light.name);

  void init() {
    final String theme =
        getIt<SharedPrefsServices>().getString(key: SharedPrefKeys.theme) ??
        ThemeMode.light.name;
    emit(theme);
  }

  void toggleTheme({required String themeMode}) {
    emit(themeMode);
    getIt<SharedPrefsServices>().setString(
      key: SharedPrefKeys.theme,
      value: themeMode,
    );
  }

  void resetTheme() {
    emit(ThemeMode.light.name);
  }

  void setDeviceTheme() {
    final Brightness brightness = MediaQuery.of(
      getIt<NavigationService>().getNavigationContext(),
    ).platformBrightness;

    String theme = brightness.name;
    emit(theme);
  }
}
