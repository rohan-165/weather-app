import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static Color whiteColor = const Color(0xFFFFFFFF);
  static Color primaryColor = const Color(0xFFFFFFFF);
  static Color secondaryColor = const Color(0xFFFFFFFF);
  static Color blackColor = const Color(0xFF2B2B2C);
  static Color lightBlack = Colors.black54;
  static Color errorColor = Colors.red;
  static Color successColor = Colors.green;
  static Color greyColor = const Color(0xFFA0A0A0);
  static Color darkGreyColor = const Color(0xFF555555);
  static Color lightGreyColor = Colors.grey[300]!;
  static Color blueAccentColor = Colors.blue[800]!;
  static Color blueColor = Colors.blue;
  static Color warningColor = Colors.yellow[800]!;
  static Color warningContanerColor = Colors.yellow[100]!;

  static Color scaffoldBackgroundColor = AppColors.whiteColor;
  static Color statusBarColor = scaffoldBackgroundColor;
  static Color appBarColor = scaffoldBackgroundColor;
}
