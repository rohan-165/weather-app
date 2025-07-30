import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/core/utils/date_time_utils.dart';
import 'package:weather_app/dashboard/domain/model/weather_model.dart';
import 'package:weather_app/dashboard/presentation/widget/image_view.dart';

class TodayForecastView extends StatefulWidget {
  final Forecastday forecastDay;
  final String? title;
  const TodayForecastView({super.key, required this.forecastDay, this.title});

  @override
  State<TodayForecastView> createState() => _TodayForecastViewState();
}

class _TodayForecastViewState extends State<TodayForecastView> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _viewMore = ValueNotifier<bool>(false);
  double itemWidth = 60.w;

  @override
  void initState() {
    super.initState();
    if ((widget.title ?? '').isNotEmpty) {
      _viewMore.value = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final index = getCurrentHourIndex(widget.forecastDay.hour ?? []);
      if (index != -1) {
        _scrollController.animateTo(
          index * itemWidth, // Estimate: width per item
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  int getCurrentHourIndex(List<Hour> hours) {
    final now = DateTime.now();
    return hours.indexWhere((e) {
      final time = DateTime.tryParse(e.time ?? '');
      return time?.hour == now.hour;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _viewMore,
      builder: (_, viewMore, __) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: context.isDark
                ? AppColors.darkGreyColor
                : AppColors.lightGreyColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title ?? 'Today Forecast',
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    viewMore ? "View less" : 'View more',
                    style: context.textTheme.bodyLarge?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ).onTap(() => _viewMore.value = !_viewMore.value),
                ],
              ).padBottom(bottom: 10.w),
              SingleChildScrollView(
                controller: _scrollController,
                primary: false,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: (widget.forecastDay.hour ?? [])
                      .map(
                        (e) => HourForecastItem(
                          time: e.time ?? "", //hour
                          temp: e.tempC, //temperature
                          wind: e.windKph, //wind (km/h)
                          rainChance: e.chanceOfRain, //rain chance (%)
                          icon: e.condition?.icon ?? '',
                          viewMore: viewMore,
                        ).padRight(right: 15.w),
                      )
                      .toList(),
                ).padVertical(vertical: 2.h),
              ),
            ],
          ).padAll(value: 15.w),
        ).padHorizontal(horizontal: 10.w);
      },
    );
  }
}

class HourForecastItem extends StatelessWidget {
  final String time;
  final dynamic temp;
  final dynamic wind;
  final dynamic rainChance;
  final String icon;
  final bool viewMore;
  const HourForecastItem({
    super.key,
    required this.icon,
    required this.rainChance,
    required this.temp,
    required this.time,
    required this.wind,
    required this.viewMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatTimeString(time),
          style: context.textTheme.bodyLarge,
        ).padBottom(bottom: 10.h),
        ImageView(url: icon, size: 50).padBottom(bottom: 10.h),

        Text(
          '$temp˚C',
          style: context.textTheme.titleMedium,
        ).padBottom(bottom: 10.h),
        if (viewMore) ...{
          Text(
            '${wind}km/h',
            style: context.textTheme.bodyMedium,
          ).padBottom(bottom: 10.h),
          FaIcon(
            FontAwesomeIcons.umbrella,
            color: AppColors.blueColor,
            size: 25.h,
          ).padBottom(bottom: 5.h),
          Text(
            '$rainChance %',
            style: context.textTheme.bodyLarge,
          ).padBottom(bottom: 10.h),
        },
      ],
    );
  }
}
