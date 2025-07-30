import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/dashboard/presentation/cubit/forecast_cubit.dart';

@lazySingleton
class SelectedLocationCubit extends Cubit<String> {
  SelectedLocationCubit() : super('kathmandu');

  void reset() => emit('kathmandu');

  void setLocation({required String value}) {
    emit(value);
    getIt<ForecastCubit>().getForecast(query: value);
  }
}
