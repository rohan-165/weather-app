import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/common/abs_normal_state.dart';
import 'package:weather_app/core/common/failure_state.dart';
import 'package:weather_app/core/constants/typedef.dart';
import 'package:weather_app/core/helper/data_parshing_helper.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/dashboard/domain/model/weather_model.dart';
import 'package:weather_app/dashboard/domain/repo/weather_repo.dart';

@lazySingleton
class ForecastCubit extends Cubit<AbsNormalState<WeatherModel>> {
  ForecastCubit() : super(AbsNormalInitialState<WeatherModel>());

  void reset() => emit(AbsNormalInitialState<WeatherModel>());

  void getForecast({required String query}) async {
    emit(AbsNormalLoadingState<WeatherModel>());

    DynamicResponse response = await getIt<WeatherRepo>().forcast(q: query);

    response.fold((l) async {
      try {
        final data = await mapSucessData(l: l, fromJson: WeatherModel.fromJson);
        emit(AbsNormalSuccessState(data: data));
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
