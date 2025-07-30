import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/constants/enum.dart';

class AppToasts {
  showToast({
    required String message,
    Color? backgroundColor,
    Toast toastLength = Toast.LENGTH_LONG,
    ToastType toastType = ToastType.INFO,
  }) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor:
          backgroundColor ??
          (toastType == ToastType.SUCCESS
              ? AppColors.successColor
              : toastType == ToastType.ERROR
              ? AppColors.errorColor
              : toastType == ToastType.WARNING
              ? AppColors.warningColor
              : toastType == ToastType.INFO
              ? AppColors.blackColor
              : AppColors.blackColor),
      gravity: ToastGravity.BOTTOM,
      fontSize: 13.sp,
      toastLength: toastLength,
    );
  }
}
