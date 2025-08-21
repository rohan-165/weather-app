// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:weather_app/core/bloc/app_open_cubit.dart';
import 'package:weather_app/core/bloc/internet_cubit.dart';
import 'package:weather_app/core/bloc/location_cubit.dart';
import 'package:weather_app/core/bloc/theme_cubit.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/dashboard/presentation/cubit/current_weather_cubit.dart';
import 'package:weather_app/dashboard/presentation/cubit/forecast_cubit.dart';
import 'package:weather_app/dashboard/presentation/cubit/search_location_cubit.dart';
import 'package:weather_app/dashboard/presentation/cubit/selected_location_cubit.dart';

BlocProvider<T> _p<T extends StateStreamableSource<Object?>>() =>
    BlocProvider<T>.value(value: getIt<T>());

List<SingleChildWidget> _coreBlocProvider() => [
  _p<AppOpenCubit>(),
  _p<InternetCubit>(),
  _p<ThemeCubit>(),
  _p<LocationCubit>(),
];

List<SingleChildWidget> _featureBlocProvider() => [
  _p<CurrentWeatherCubit>(),
  _p<ForecastCubit>(),
  _p<SearchLocationCubit>(),
  _p<SelectedLocationCubit>(),
];

List<SingleChildWidget> globalBlocProvider() => [
  ..._coreBlocProvider(),
  ..._featureBlocProvider(),
];
