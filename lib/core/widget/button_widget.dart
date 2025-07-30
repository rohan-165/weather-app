import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/core/utils/debounc_utils.dart';
import 'package:weather_app/core/utils/decore_utils.dart';
import 'package:weather_app/core/widget/loader_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String? lable;
  final VoidCallback onTap;
  final Color? buttonColor, lableColor, borderColor;
  final double? width;
  final double? height;
  final double horizontal;
  final bool isLoading;
  const ButtonWidget({
    super.key,
    this.lable,
    required this.onTap,
    this.buttonColor,
    this.lableColor,
    this.borderColor,
    this.width,
    this.height,
    this.horizontal = 0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          height: height?.h ?? 48.h,
          alignment: Alignment.center,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color:
                (buttonColor ??
                (context.isDark
                    ? AppColors.primaryColor
                    : AppColors.primaryColor)),
            border: Border.all(
              color:
                  (borderColor ??
                  (context.isDark
                      ? AppColors.primaryColor
                      : AppColors.primaryColor)),
            ),
          ),
          child: isLoading
              ? LoaderWidget(
                  dotColor: AppColors.whiteColor,
                ).padVertical(vertical: 8.h)
              : Text(
                  lable ?? 'Submit',
                  style: context.textTheme.titleMedium!.copyWith(
                    color:
                        lableColor ??
                        (context.isDark
                            ? AppColors.whiteColor
                            : AppColors.whiteColor),
                  ),
                ).padHorizontal(horizontal: 20.w).padVertical(vertical: 8.h),
        )
        .onTap(() {
          DebounceUtils().run(onTap);
        })
        .padHorizontal(horizontal: horizontal);
  }
}

Widget alertButton(
  BuildContext context, {
  required String lable,
  bool isOk = true,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
    alignment: Alignment.center,
    width: 0.3.sw,
    decoration: boxDecoration(
      context,
      color: isOk ? AppColors.primaryColor : null,
      borderColor: AppColors.primaryColor,
    ),
    child: Text(
      lable,
      style: context.textTheme.titleMedium?.copyWith(
        color: isOk ? AppColors.whiteColor : null,
      ),
    ),
  );
}
