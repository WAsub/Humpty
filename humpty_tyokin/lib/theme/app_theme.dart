import 'package:flutter/material.dart';
import 'color.dart';

class AppTheme {
  static ThemeData theme_basic() {
    return ThemeData(
      primaryColor: MyColor.basic[1],
      accentColor: MyColor.basic[2],
      selectedRowColor: MyColor.basic[3],
      focusColor: MyColor.basic[2],
      brightness: Brightness.light, 
      textSelectionTheme: TextSelectionThemeData(cursorColor: MyColor.basic[2]),
    );
  }
  static ThemeData theme_rose() {
    return ThemeData(
      primaryColor: MyColor.rose[1],
      accentColor: MyColor.rose[2],
      selectedRowColor: MyColor.rose[3],
      brightness: Brightness.light,
    );
  }
  static ThemeData theme_sky() {
    return ThemeData(
      primaryColor: MyColor.sky[1],
      accentColor: MyColor.sky[2],
      selectedRowColor: MyColor.sky[3],
      brightness: Brightness.light,
    );
  }

}