import 'package:flutter/material.dart';

class CustomColors {
  static const Color primaryColor = Color(0xFF279EFF);
  static const Color secondaryColor = Color(0xFF0C356A);
  static const Color accentColor = Color(0xFF40F8FF);
  static const Color backgroundColor = Color(0xFFD5FFD0);
}

MaterialColor customPrimaryColor = MaterialColor(
  CustomColors.primaryColor.value,
  <int, Color>{
    50: CustomColors.primaryColor.withOpacity(0.1),
    100: CustomColors.primaryColor.withOpacity(0.2),
    200: CustomColors.primaryColor.withOpacity(0.3),
    300: CustomColors.primaryColor.withOpacity(0.4),
    400: CustomColors.primaryColor.withOpacity(0.5),
    500: CustomColors.primaryColor.withOpacity(0.6),
    600: CustomColors.primaryColor.withOpacity(0.7),
    700: CustomColors.primaryColor.withOpacity(0.8),
    800: CustomColors.primaryColor.withOpacity(0.9),
    900: CustomColors.primaryColor.withOpacity(1.0),
  },
);
