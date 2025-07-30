// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../../dashboard/data/weather_repo_impl.dart' as _i198;
import '../../../dashboard/domain/repo/weather_repo.dart' as _i25;
import '../../../dashboard/presentation/cubit/current_weather_cubit.dart'
    as _i989;
import '../../../dashboard/presentation/cubit/forecast_cubit.dart' as _i856;
import '../../../dashboard/presentation/cubit/search_location_cubit.dart'
    as _i237;
import '../../../dashboard/presentation/cubit/selected_location_cubit.dart'
    as _i300;
import '../../bloc/app_open_cubit.dart' as _i150;
import '../../bloc/internet_cubit.dart' as _i636;
import '../../bloc/location_cubit.dart' as _i67;
import '../../bloc/theme_cubit.dart' as _i1027;
import '../../routes/navigation_service.dart' as _i113;
import '../local_storage/shared_pref_module.dart' as _i421;
import '../local_storage/shared_pref_service.dart' as _i942;
import '../network_service/api_manager.dart' as _i609;
import '../network_service/api_request.dart' as _i601;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final sharedPrefsModule = _$SharedPrefsModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPrefsModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i300.SelectedLocationCubit>(
      () => _i300.SelectedLocationCubit(),
    );
    gh.lazySingleton<_i989.CurrentWeatherCubit>(
      () => _i989.CurrentWeatherCubit(),
    );
    gh.lazySingleton<_i856.ForecastCubit>(() => _i856.ForecastCubit());
    gh.lazySingleton<_i237.SearchLocationCubit>(
      () => _i237.SearchLocationCubit(),
    );
    gh.lazySingleton<_i67.LocationCubit>(() => _i67.LocationCubit());
    gh.lazySingleton<_i1027.ThemeCubit>(() => _i1027.ThemeCubit());
    gh.lazySingleton<_i150.AppOpenCubit>(() => _i150.AppOpenCubit());
    gh.lazySingleton<_i636.InternetCubit>(() => _i636.InternetCubit());
    gh.lazySingleton<_i609.ApiManager>(() => _i609.ApiManager());
    gh.lazySingleton<_i113.NavigationService>(() => _i113.NavigationService());
    gh.lazySingleton<_i601.ApiRequest>(
      () => _i601.ApiRequestImpl(gh<_i609.ApiManager>()),
    );
    gh.lazySingleton<_i25.WeatherRepo>(() => _i198.WeatherRepoImpl());
    gh.lazySingleton<_i942.SharedPrefsServices>(
      () => _i942.SharedPrefsServices(gh<_i460.SharedPreferences>()),
    );
    return this;
  }
}

class _$SharedPrefsModule extends _i421.SharedPrefsModule {}
