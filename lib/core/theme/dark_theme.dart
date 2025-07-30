import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/extension/build_context_extension.dart';

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    textTheme: TextTheme(
      displayLarge: context.textTheme.displayLarge?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 34.sp,
        fontWeight: FontWeight.bold,
        height: 0,
        letterSpacing: 0,
      ),
      displayMedium: context.textTheme.displayMedium?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 30.sp,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0,
      ),
      displaySmall: context.textTheme.displaySmall?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 28.sp,
        fontWeight: FontWeight.w500,
        height: 0,
        letterSpacing: 0,
      ),
      headlineLarge: context.textTheme.headlineLarge?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 26.sp,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0,
      ),
      headlineMedium: context.textTheme.headlineMedium?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        height: 0,
        letterSpacing: 0,
      ),
      headlineSmall: context.textTheme.headlineSmall?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.w400,
        height: 0,
        letterSpacing: 0,
      ),
      titleLarge: context.textTheme.titleLarge?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0,
      ),
      titleMedium: context.textTheme.titleMedium?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        height: 0,
        letterSpacing: 0,
      ),
      titleSmall: context.textTheme.titleSmall?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 0,
        letterSpacing: 0,
      ),
      bodyLarge: context.textTheme.bodyLarge?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        height: 0,
        letterSpacing: 0,
      ),
      bodyMedium: context.textTheme.bodyMedium?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.normal,
        height: 0,
        letterSpacing: 0,
      ),
      bodySmall: context.textTheme.bodySmall?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        height: 0,
        letterSpacing: 0,
      ),
      labelLarge: context.textTheme.labelLarge?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0,
      ),
      labelMedium: context.textTheme.labelMedium?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 0,
        letterSpacing: 0,
      ),
      labelSmall: context.textTheme.labelSmall?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        height: 0,
        letterSpacing: 0,
      ),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.statusBarColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      toolbarHeight: 56.h,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.whiteColor),
      titleTextStyle: context.textTheme.headlineMedium?.copyWith(
        color: AppColors.whiteColor,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0,
      ),
      actionsIconTheme: IconThemeData(color: AppColors.whiteColor, size: 24.sp),
      elevation: 0,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.whiteColor;
        }
        return AppColors.whiteColor;
      }),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.secondaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: IconThemeData(color: AppColors.whiteColor),
    cardColor: AppColors.darkGreyColor,
    cardTheme: CardThemeData(
      color: AppColors.darkGreyColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.r),
        side: BorderSide(color: AppColors.darkGreyColor, width: 1.0),
      ),
    ),

    dividerColor: AppColors.darkGreyColor,
    dividerTheme: DividerThemeData(
      color: AppColors.darkGreyColor,
      thickness: 1.0,
      space: 16.0,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkGreyColor,
      secondary: AppColors.darkGreyColor,
      surface: AppColors.darkGreyColor,
      error: AppColors.darkGreyColor,
      onPrimary: AppColors.whiteColor,
      onSecondary: AppColors.whiteColor,
      onSurface: AppColors.whiteColor,
    ),
  );
}
