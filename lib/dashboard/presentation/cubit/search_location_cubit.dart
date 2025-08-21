import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/common/abs_normal_state.dart';
import 'package:weather_app/core/common/failure_state.dart';
import 'package:weather_app/core/constants/typedef.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/utils/debug_log_utils.dart';
import 'package:weather_app/dashboard/domain/model/search_location_model.dart';
import 'package:weather_app/dashboard/domain/repo/weather_repo.dart';

@lazySingleton
class SearchLocationCubit
    extends Cubit<AbsNormalState<List<SearchLocationModel>>> {
  SearchLocationCubit()
    : super(AbsNormalInitialState<List<SearchLocationModel>>());

  void reset() => emit(AbsNormalInitialState<List<SearchLocationModel>>());

  void search({required String query}) async {
    emit(AbsNormalLoadingState<List<SearchLocationModel>>());

    DynamicResponse response = await getIt<WeatherRepo>().searchLocation(
      q: query,
    );

    response.fold(
      (l) {
        try {
          final data = (l is Map) ? l['data'] : null;

          if (data is List) {
            final locations = data
                .map((e) => SearchLocationModel.fromJson(e))
                .toList();

            emit(
              AbsNormalSuccessState<List<SearchLocationModel>>(data: locations),
            );
          } else {
            DebugLoggerService.log(
              "Error on data format",
              level: LogLevel.warning,
            );
            emit(
              AbsNormalFailureState<List<SearchLocationModel>>(
                failure: Failure(message: 'Invalid data format'),
              ),
            );
          }
        } catch (e) {
          emit(
            AbsNormalFailureState<List<SearchLocationModel>>(
              failure: Failure(message: e.toString()),
            ),
          );
          rethrow;
        }
      },
      (r) => emit(AbsNormalFailureState<List<SearchLocationModel>>(failure: r)),
    );
  }
}
