import 'package:flutter/material.dart';
import 'package:flutter_tourism_app/utils/app_colors.dart';



ThemeData appThemes() {
  return ThemeData(
      scaffoldBackgroundColor: AppColor.surfaceBackgroundBaseColor,
      appBarTheme:  AppBarTheme(
          elevation: 0, backgroundColor: AppColor.surfaceBrandDarkColor));
}
