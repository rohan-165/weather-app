import 'package:flutter/material.dart';
import 'package:weather_app/core/routes/routes_name.dart';
import 'package:weather_app/dashboard/presentation/screen/location_search_screen.dart';
import 'package:weather_app/dashboard/presentation/screen/seven_day_forecast_screen.dart';
import 'package:weather_app/dashboard/presentation/screen/weather_screen.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case RoutesName.weatherScreen:
        return _materialPageRoute(const WeatherScreen(), settings);

      case RoutesName.sevendayForecastScreen:
        return _materialPageRoute(const SevenDayForecastScreen(), settings);

      case RoutesName.searchLocationScreen:
        return _materialPageRoute(const LocationSearchScreen(), settings);

      default:
        return _unknownRoute(settings);
    }
  }

  static MaterialPageRoute _materialPageRoute(
    Widget screen,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(settings: settings, builder: (_) => screen);
  }

  static MaterialPageRoute _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const WeatherScreen(),
    );
  }
}
