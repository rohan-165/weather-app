import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/constants/app_assets.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';

class NoDataWidget extends StatelessWidget {
  final double? height;
  final String? title;
  final String? subtitle;
  const NoDataWidget({super.key, this.height, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.appLogo,
            height: height?.h ?? 100.h,
          ).padBottom(bottom: 20.h),
          Text(
            title ?? "No Data",
            style: context.textTheme.titleLarge,
          ).padBottom(bottom: 10.h),
          Text(
            subtitle ?? "No Data Found !.",
            style: context.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ).padBottom(bottom: 10.h),
        ],
      ).padHorizontal(horizontal: 10.w),
    );
  }
}
