import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/common/abs_normal_state.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/constants/enum.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/utils/date_time_utils.dart';
import 'package:weather_app/core/widget/loader_widget.dart';
import 'package:weather_app/dashboard/domain/model/weather_model.dart';
import 'package:weather_app/dashboard/presentation/cubit/forecast_cubit.dart';
import 'package:weather_app/dashboard/presentation/widget/today_forecast_view.dart';

class SevenDayForecastScreen extends StatefulWidget {
  const SevenDayForecastScreen({super.key});

  @override
  State<SevenDayForecastScreen> createState() => _SevenDayForecastScreenState();
}

class _SevenDayForecastScreenState extends State<SevenDayForecastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Seven Day Forecast',
          style: context.textTheme.displayMedium,
        ),
      ),
      body: BlocBuilder<ForecastCubit, AbsNormalState<WeatherModel>>(
        builder: (context, forecasteState) {
          if (forecasteState.absNormalStatus == AbsNormalStatus.INITIAL ||
              forecasteState.absNormalStatus == AbsNormalStatus.LOADING) {
            return Center(
              child: LoaderWidget(dotColor: AppColors.blueAccentColor),
            );
          } else if (forecasteState.absNormalStatus == AbsNormalStatus.ERROR) {
            return Center(
              child: Text(
                forecasteState.failure?.message ?? 'Error',
                style: context.textTheme.displayLarge,
              ),
            );
          } else if (forecasteState.absNormalStatus ==
              AbsNormalStatus.SUCCESS) {
            return SafeArea(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount:
                    (forecasteState.data?.forecast?.forecastday ?? []).length,
                separatorBuilder: (context, index) => 20.verticalSpace,
                itemBuilder: (context, index) {
                  Forecastday forecastday =
                      (forecasteState.data?.forecast?.forecastday ?? [])[index];
                  return TodayForecastView(
                    title: getDayLabel(forecastday.date ?? ''),
                    forecastDay: forecastday,
                  );
                },
              ),
            );
          } else {
            return Center(child: Text("No Data To Load"));
          }
        },
      ),
    );
  }
}
