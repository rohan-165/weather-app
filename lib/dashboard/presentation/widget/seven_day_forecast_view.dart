import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/core/routes/navigation_service.dart';
import 'package:weather_app/core/routes/routes_name.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/utils/date_time_utils.dart';
import 'package:weather_app/dashboard/domain/model/weather_model.dart';
import 'package:weather_app/dashboard/presentation/widget/image_view.dart';

class SevenDayForecastView extends StatelessWidget {
  final Forecast forecast;
  const SevenDayForecastView({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: context.isDark
            ? AppColors.darkGreyColor
            : AppColors.lightGreyColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "7-Day Forecast",
                  style: context.textTheme.titleLarge,
                ).padBottom(bottom: 10.h),
              ),
              Text(
                    "More detail",
                    style: context.textTheme.bodyLarge?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  )
                  .onTap(
                    () => getIt<NavigationService>().pushNamed(
                      RoutesName.sevendayForecastScreen,
                    ),
                  )
                  .padBottom(bottom: 10.h),
            ],
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: forecast.forecastday?.length,
            itemBuilder: (context, index) {
              Forecastday forecastday =
                  forecast.forecastday?[index] ?? Forecastday();
              return SevenDayForecastItem(
                time: forecastday.date ?? "",
                text: forecastday.day?.condition?.text ?? '',
                minTemp: forecastday.day?.mintempC ?? 0,
                maxTemp: forecastday.day?.maxtempC ?? 0,
                imagePath: forecastday.day?.condition?.icon ?? '',
              );
            },
          ),
        ],
      ).padAll(value: 10.w),
    ).padHorizontal(horizontal: 10.w);
  }
}

class SevenDayForecastItem extends StatelessWidget {
  final String time;
  final String text;
  final dynamic minTemp;
  final dynamic maxTemp;
  final String imagePath;
  const SevenDayForecastItem({
    super.key,
    required this.imagePath,
    required this.maxTemp,
    required this.minTemp,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImageView(url: imagePath, size: 40).padRight(right: 10.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: getDayLabel(time),
              style: context.textTheme.bodyMedium,
              children: [
                TextSpan(text: '  $text', style: context.textTheme.bodyMedium),
              ],
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            text: '$maxTemp˚',
            style: context.textTheme.bodyMedium,
            children: [
              TextSpan(
                text: '/ $minTemp˚',
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
