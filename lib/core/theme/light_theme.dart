import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    textTheme: TextTheme(
      displayLarge: context.textTheme.displayLarge?.copyWith(
        color: AppColors.blackColor,
        fontSize: 34.sp,
        fontWeight: FontWeight.bold,
        height: 0,
        letterSpacing: 0,
      ),
      displayMedium: context.textTheme.displayMedium?.copyWith(
        color: AppColors.blackColor,
        fontSize: 30.sp,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0,
      ),
      displaySmall: context.textTheme.displaySmall?.copyWith(
        color: AppColors.blackColor,
        fontSize: 28.sp,
        fontWeight: FontWeight.w500,
        height: 0,
        letterSpacing: 0,
      ),
      headlineLarge: context.textTheme.headlineLarge?.copyWith(
        color: AppColors.blackColor,
        fontSize: 26.sp,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0,
      ),
      headlineMedium: context.textTheme.headlineMedium?.copyWith(
        color: AppColors.blackColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        height: 0,
        letterSpacing: 0,
      ),
      headlineSmall: context.textTheme.headlineSmall?.copyWith(
        color: AppColors.blackColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.w400,
        height: 0,
        letterSpacing: 0,
      ),
      titleLarge: context.textTheme.titleLarge?.copyWith(
        color: AppColors.blackColor,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0,
      ),
      titleMedium: context.textTheme.titleMedium?.copyWith(
        color: AppColors.blackColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        height: 0,
        letterSpacing: 0,
      ),
      titleSmall: context.textTheme.titleSmall?.copyWith(
        color: AppColors.blackColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 0,
        letterSpacing: 0,
      ),
      bodyLarge: context.textTheme.bodyLarge?.copyWith(
        color: AppColors.blackColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        height: 0,
        letterSpacing: 0,
      ),
      bodyMedium: context.textTheme.bodyMedium?.copyWith(
        color: AppColors.blackColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.normal,
        height: 0,
        letterSpacing: 0,
      ),
      bodySmall: context.textTheme.bodySmall?.copyWith(
        color: AppColors.blackColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        height: 0,
        letterSpacing: 0,
      ),
      labelLarge: context.textTheme.labelLarge?.copyWith(
        color: AppColors.blackColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0,
      ),
      labelMedium: context.textTheme.labelMedium?.copyWith(
        color: AppColors.blackColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 0,
        letterSpacing: 0,
      ),
      labelSmall: context.textTheme.labelSmall?.copyWith(
        color: AppColors.blackColor,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        height: 0,
        letterSpacing: 0,
      ),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.statusBarColor,
        systemNavigationBarColor: AppColors.statusBarColor,
        systemNavigationBarDividerColor: AppColors.statusBarColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      toolbarHeight: 56.h,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.blackColor),
      titleTextStyle: context.textTheme.headlineMedium?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0,
      ),
      actionsIconTheme: IconThemeData(color: AppColors.blackColor, size: 24.sp),
      elevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.blackColor;
        }
        return AppColors.blackColor;
      }),
    ),
    canvasColor: AppColors.scaffoldBackgroundColor,
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.scaffoldBackgroundColor,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: AppColors.primaryColor,
      error: AppColors.errorColor,
      onPrimary: AppColors.primaryColor,
      onSecondary: AppColors.secondaryColor,
      onSurface: AppColors.blackColor,
    ),
    cardColor: AppColors.lightBlack,
    iconTheme: IconThemeData(color: AppColors.blackColor, size: 24.sp),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        textStyle: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.primaryColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          height: 0,
          letterSpacing: 0,
        ),
      ),
    ),
  );
}
