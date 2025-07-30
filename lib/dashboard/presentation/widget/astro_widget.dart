import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/dashboard/domain/model/weather_model.dart';

class AstroWidget extends StatelessWidget {
  final Astro astro;
  const AstroWidget({super.key, required this.astro});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Icon(Icons.wb_sunny_outlined, size: 30.w),
                  Text("Sunrise", style: context.textTheme.bodyMedium),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.nights_stay_outlined, size: 30.w),
                  Text("Sunset", style: context.textTheme.bodyMedium),
                ],
              ),
            ],
          ).padBottom(bottom: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                astro.sunrise ?? '',
                style: context.textTheme.headlineMedium,
              ),
              Text(astro.sunset ?? '', style: context.textTheme.headlineMedium),
            ],
          ),
        ],
      ),
    ).padHorizontal(horizontal: 10.w);
  }
}
