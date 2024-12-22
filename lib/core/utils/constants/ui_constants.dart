import 'package:flutter/material.dart';

abstract class AppStyles {}

abstract class AppColors {
  static const Color primaryColor = Color(0xFF876DDC);
  static const Color secondaryColor = Color(0xFFB19DF2);
  static const Color lightColor = Color(0xFFF2F2F2);
  static const Color darkColor = Color(0xFF1F2833);
  static const Color textColor = Color(0xFF737373);
  static const Color errorColor = Color(0xFFD9534F);
  static const Color backgroundColor = Color(0xFFFFFFFF);
}

abstract class AppTypography {
  static const TextStyle header1 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  static const TextStyle header2 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  static const TextStyle header3 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );
  static const TextStyle body1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );
  static const TextStyle body2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.darkColor,
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.backgroundColor,
  );
  static const TextStyle errorText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.errorColor,
  );
}

abstract class AppGradientColors {
  static const List<Color> primaryGradient = [
    AppColors.primaryColor,
    AppColors.secondaryColor,
  ];
  static const List<Color> secondaryGradient = [
    AppColors.secondaryColor,
    AppColors.primaryColor,
  ];
  static const List<Color> lightGradient = [
    AppColors.lightColor,
    AppColors.backgroundColor,
  ];
}

abstract class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: AppGradientColors.primaryGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: AppGradientColors.secondaryGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient lightGradient = LinearGradient(
    colors: AppGradientColors.lightGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
