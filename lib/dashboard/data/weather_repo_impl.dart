import 'package:injectable/injectable.dart';
import 'package:weather_app/core/constants/typedef.dart';
import 'package:weather_app/core/env/get_env_config.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/services/network_service/api_request.dart';
import 'package:weather_app/dashboard/domain/repo/weather_repo.dart';

@LazySingleton(as: WeatherRepo)
class WeatherRepoImpl extends WeatherRepo {
  static final String apiKey = GetEnvConfig.apiKey;
  static final String current = '/current.json';
  static final String forecast = '/forecast.json';
  static final String search = '/search.json';

  @override
  FutureDynamicResponse currentWeather({required String q}) async {
    return getIt<ApiRequest>().getResponse(
      endPoint: current,
      apiMethods: ApiMethods.get,
      queryParams: {'key': apiKey, 'q': q},
    );
  }

  @override
  FutureDynamicResponse forcast({required String q}) async {
    return getIt<ApiRequest>().getResponse(
      endPoint: forecast,
      apiMethods: ApiMethods.get,
      queryParams: {'key': apiKey, 'q': q, 'days': 7},
    );
  }

  @override
  FutureDynamicResponse searchLocation({required String q}) async {
    return getIt<ApiRequest>().getResponse(
      endPoint: search,
      apiMethods: ApiMethods.get,
      queryParams: {'key': apiKey, 'q': q},
    );
  }
}
