import 'package:weather_app/core/constants/typedef.dart';

abstract class WeatherRepo {
  FutureDynamicResponse currentWeather({required String q});
  FutureDynamicResponse forcast({required String q});
  FutureDynamicResponse searchLocation({required String q});
}
