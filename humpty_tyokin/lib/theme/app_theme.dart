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
      colorScheme: scheme_basic(),
      textTheme: text_basic(MyColor.basic[2]),
      primaryTextTheme: text_basic(Colors.white),
      accentTextTheme: text_basic(Colors.white),
      iconTheme: icon_basic(),
      primaryIconTheme: icon_basic(),
      accentIconTheme: icon_basic(),
      textSelectionTheme: TextSelectionThemeData(cursorColor: MyColor.basic[2]),
    );
  }
  static ColorScheme scheme_basic(){
    return ColorScheme(
      primary: MyColor.basic[3],
      secondary: MyColor.basic[5],  
      background: MyColor.basic[1], 
      brightness: Brightness.light, 
      primaryVariant: MyColor.basic[5], 
      secondaryVariant: MyColor.basic[5], 
      surface: MyColor.basic[5],
      error: MyColor.basic[5], 
      onPrimary: MyColor.basic[5], 
      onSecondary: MyColor.basic[5], 
      onBackground: MyColor.basic[5], 
      onSurface: MyColor.basic[5], 
      onError: MyColor.basic[5], 
    );
  }
  static TextTheme text_basic(color){
    return TextTheme(
      bodyText1: TextStyle(color: color),
      bodyText2: TextStyle(color: color),
      headline1:  TextStyle(color: color),
      headline2:  TextStyle(color: color),
      headline3:  TextStyle(color: color),
      headline4:  TextStyle(color: color),
      headline5:  TextStyle(color: color),
      headline6:  TextStyle(color: color),
      subtitle1:  TextStyle(color: color),
      subtitle2:  TextStyle(color: color),
      button: TextStyle(color: color),
    );
  }
  static IconThemeData icon_basic(){
    return IconThemeData(
      color: Colors.white,
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