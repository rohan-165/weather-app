import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/common/abs_normal_state.dart';
import 'package:weather_app/core/constants/enum.dart';
import 'package:weather_app/core/mixin/location_mixin.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/dashboard/presentation/cubit/selected_location_cubit.dart';

@lazySingleton
class LocationCubit extends Cubit<AbsNormalState<LocationModel>>
    with LocationMixin {
  LocationCubit() : super(AbsNormalInitialState<LocationModel>());

  void reset() {
    emit(AbsNormalInitialState<LocationModel>());
  }

  void init() async {
    emit(AbsNormalLoadingState<LocationModel>());
    try {
      LocationModel location = await getCurrentLocation();
      emit(
        state.copyWith(
          absNormalStatus: AbsNormalStatus.SUCCESS,
          data: location,
        ),
      );
      if ((location.gps ?? '').isNotEmpty) {
        getIt<SelectedLocationCubit>().setLocation(
          value: location.gps ?? 'kathmandu',
        );
      }
    } catch (e) {
      emit(state.copyWith(absNormalStatus: AbsNormalStatus.ERROR));
      rethrow;
    }
  }
}
