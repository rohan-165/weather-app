import 'package:flutter/material.dart';
import 'package:weather_app/core/routes/routes_name.dart';
import 'package:weather_app/dashboard/presentation/screen/location_search_screen.dart';
import 'package:weather_app/dashboard/presentation/screen/seven_day_forecast_screen.dart';
import 'package:weather_app/dashboard/presentation/screen/weather_screen.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Object? argument = settings.arguments;

    switch (settings.name) {
      case RoutesName.weatherScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WeatherScreen(),
        );
      case RoutesName.sevendayForecastScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SevenDayForecastScreen(),
        );
      case RoutesName.searchLocationScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LocationSearchScreen(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) => const WeatherScreen(),
        );
    }
  }
}
