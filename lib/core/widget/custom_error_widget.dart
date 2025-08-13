import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/constants/app_assets.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/core/widget/button_widget.dart';

class CustomErrorWidget extends StatelessWidget {
  final double? height;
  final String? title;
  final String? subTitle;
  final VoidCallback onRetry;
  const CustomErrorWidget({
    super.key,
    this.height,
    this.subTitle,
    this.title,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppAssets.appLogo, height: height?.h ?? 250.h),
          Text(
            title ?? 'Something went wrong',
            style: context.textTheme.titleLarge,
          ).padBottom(bottom: 5.h),
          Text(
            subTitle ?? "Something went wrong ! Try agian.",
            style: context.textTheme.titleMedium,
          ).padBottom(bottom: 10.h),

          ButtonWidget(
            height: 35.h,
            width: 120.w,
            lable: 'Retry',
            onTap: onRetry,
          ).padBottom(bottom: 10.h),
        ],
      ).padHorizontal(horizontal: 10.w),
    );
  }
}
