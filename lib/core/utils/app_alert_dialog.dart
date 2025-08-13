// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/constants/app_assets.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';
import 'package:weather_app/core/extension/widget_extensions.dart';
import 'package:weather_app/core/routes/navigation_service.dart';
import 'package:weather_app/core/services/get_it/service_locator.dart';
import 'package:weather_app/core/utils/decore_utils.dart';
import 'package:weather_app/core/widget/button_widget.dart';

class AppAlertDialog {
  static Future<void> showAlertDialog(
    BuildContext context, {
    String? icon,
    required String lable,
    String? message,
    Widget? child,
    Function()? okTap,
    Function()? cancelTap,
    String? buttonLable,
    String? secondbuttonLable,
    EdgeInsets? contentPadding,
    bool iconColor = true,
    bool barrierDismissible = true,
  }) async {
    return await showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: AlertDialogWidget(
          icon: icon,
          iconColor: iconColor,
          lable: lable,
          message: message,
          okTap: okTap,
          cancelTap: cancelTap,
          buttonLable: buttonLable,
          secondbuttonLable: secondbuttonLable,
          child: child,
        ),
      ),
    );
  }
}

class AlertDialogWidget extends StatelessWidget {
  final String? icon;
  final bool iconColor;
  final String lable;
  final String? message;
  final Function()? okTap;
  final Function()? cancelTap;
  final String? buttonLable;
  final String? secondbuttonLable;
  final Widget? child;
  const AlertDialogWidget({
    super.key,
    this.icon,
    this.iconColor = true,
    required this.lable,
    this.message,
    this.okTap,
    this.cancelTap,
    this.buttonLable,
    this.secondbuttonLable,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          width: double.maxFinite,
          decoration: boxDecoration(
            context,
            color: context.isDark
                ? AppColors.darkGreyColor
                : AppColors.whiteColor,
            borderColor: context.isDark
                ? AppColors.darkGreyColor
                : AppColors.whiteColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                lable,
                style: context.textTheme.titleLarge,
              ).padBottom(bottom: 10.h).padTop(top: 10.h),
              if (child != null) ...{child!},
              if ((message ?? '').isNotEmpty) ...{
                Text(
                  message ?? '',
                  textAlign: TextAlign.center,
                ).padBottom(bottom: 20.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    alertButton(
                          context,
                          lable: secondbuttonLable ?? 'Cancel',
                          isOk: false,
                        )
                        .padRight(right: 10.w)
                        .onTap(
                          cancelTap != null
                              ? () => cancelTap!()
                              : () => getIt<NavigationService>().goBack(),
                        ),
                    alertButton(context, lable: buttonLable ?? 'Ok').onTap(
                      okTap != null
                          ? () => okTap!()
                          : () => getIt<NavigationService>().goBack(),
                    ),
                  ],
                ),
              },
            ],
          ),
        ),
        Positioned(
          top: -25,
          left: 0.w,
          right: 0.w,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(90),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: EdgeInsets.all(5.w),
              child: Image.asset(
                icon ?? AppAssets.appLogo,
                height: 30.w,
                width: 30.w,
                color: iconColor ? AppColors.primaryColor : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
