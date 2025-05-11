import 'package:braille_app/utils/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final theme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    fontFamily: 'Poppins',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(350, 48),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        textStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: AppColors.whiteColor,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
