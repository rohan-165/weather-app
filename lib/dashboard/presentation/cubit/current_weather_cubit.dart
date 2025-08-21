import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/common/abs_normal_state.dart';
import 'package:weather_app/core/common/failure_state.dart';
import 'package:weather_app/core/constants/typedef.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/utils/debug_log_utils.dart';
import 'package:weather_app/dashboard/domain/model/weather_model.dart';
import 'package:weather_app/dashboard/domain/repo/weather_repo.dart';

@lazySingleton
class CurrentWeatherCubit extends Cubit<AbsNormalState<WeatherModel>> {
  CurrentWeatherCubit() : super(AbsNormalInitialState<WeatherModel>());

  void reset() => emit(AbsNormalInitialState<WeatherModel>());

  void getCurrentWeather({required String query}) async {
    emit(AbsNormalLoadingState<WeatherModel>());

    DynamicResponse response = await getIt<WeatherRepo>().currentWeather(
      q: query,
    );

    response.fold((l) {
      try {
        if (l is Map &&
            l.containsKey('data') &&
            l['data'] is Map &&
            l['data'] != null) {
          final data = l['data'];
          emit(AbsNormalSuccessState(data: WeatherModel.fromJson(data)));
        } else {
          DebugLoggerService.log(
            "Error on data formate",
            level: LogLevel.warning,
          );
        }
      } catch (e) {
        emit(
          AbsNormalFailureState<WeatherModel>(
            failure: Failure(message: e.toString()),
          ),
        );
        rethrow;
      }
    }, (r) => emit(AbsNormalFailureState<WeatherModel>(failure: r)));
  }
}
