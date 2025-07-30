import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/common/abs_normal_state.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/constants/enum.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/core/routes/navigation_service.dart';
import 'package:weather_app/core/routes/routes_name.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/widget/app_exit_widget.dart';
import 'package:weather_app/core/widget/loader_widget.dart';
import 'package:weather_app/core/widget/pull_to_refresh_widget.dart';
import 'package:weather_app/dashboard/domain/model/weather_model.dart';
import 'package:weather_app/dashboard/presentation/cubit/forecast_cubit.dart';
import 'package:weather_app/dashboard/presentation/cubit/selected_location_cubit.dart';
import 'package:weather_app/dashboard/presentation/widget/astro_widget.dart';
import 'package:weather_app/dashboard/presentation/widget/current_temp_view.dart';
import 'package:weather_app/dashboard/presentation/widget/other_info.dart';
import 'package:weather_app/dashboard/presentation/widget/seven_day_forecast_view.dart';
import 'package:weather_app/dashboard/presentation/widget/today_forecast_view.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return AppExit(
      canPop: false,
      child: Scaffold(
        body: BlocBuilder<SelectedLocationCubit, String>(
          builder: (context, location) {
            return BlocBuilder<ForecastCubit, AbsNormalState<WeatherModel>>(
              builder: (context, forecasteState) {
                if (forecasteState.absNormalStatus == AbsNormalStatus.INITIAL ||
                    forecasteState.absNormalStatus == AbsNormalStatus.LOADING) {
                  return Center(
                    child: LoaderWidget(dotColor: AppColors.blueAccentColor),
                  );
                } else if (forecasteState.absNormalStatus ==
                    AbsNormalStatus.ERROR) {
                  return SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            forecasteState.failure?.message ?? 'Error',
                            style: context.textTheme.headlineLarge,
                          ).padBottom(bottom: 20.h),
                          TextButton(
                            onPressed: () => getIt<ForecastCubit>().getForecast(
                              query: location,
                            ),
                            child: Text(
                              "Retry",
                              style: context.textTheme.headlineLarge?.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ).padHorizontal(horizontal: 20.w),
                    ),
                  );
                } else if (forecasteState.absNormalStatus ==
                    AbsNormalStatus.SUCCESS) {
                  return SafeArea(
                    child: PullToRefreshWidget(
                      onLoading: () {},
                      onRefresh: () =>
                          getIt<ForecastCubit>().getForecast(query: location),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              forecasteState.data?.location?.name ?? '',
                              style: context.textTheme.displayMedium,
                            ).padTop(top: 10.h),

                            CurrentTempView(
                              current:
                                  forecasteState.data?.current ?? Current(),
                              forecast:
                                  forecasteState.data?.forecast ?? Forecast(),
                            ).padBottom(bottom: 10.h),
                            AstroWidget(
                              astro:
                                  forecasteState
                                      .data
                                      ?.forecast
                                      ?.forecastday
                                      ?.firstOrNull
                                      ?.astro ??
                                  Astro(),
                            ).padBottom(bottom: 10.h),
                            TodayForecastView(
                              forecastDay:
                                  forecasteState
                                      .data
                                      ?.forecast
                                      ?.forecastday
                                      ?.firstOrNull ??
                                  Forecastday(),
                            ).padBottom(bottom: 10.h),
                            SevenDayForecastView(
                              forecast:
                                  forecasteState.data?.forecast ?? Forecast(),
                            ).padBottom(bottom: 10.h),
                            OtherInfo(
                              current:
                                  forecasteState.data?.current ?? Current(),
                            ).padBottom(bottom: 100.h),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text("No Data To Load"));
                }
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => getIt<NavigationService>().pushNamed(
            RoutesName.searchLocationScreen,
          ),
          child: Icon(
            Icons.add_location_alt_outlined,
            size: 30.w,
            color: context.isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
