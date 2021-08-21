import 'package:flutter/material.dart';

import 'color.dart';

class AppTheme {
  static ThemeData theme_basic() {
    return ThemeData(
      primaryColor: MyColor.basic[1],
      accentColor: MyColor.basic[2],
      selectedRowColor: MyColor.basic[3],
      brightness: Brightness.light, 
      primaryTextTheme: text_basic(Colors.white),
      primaryIconTheme: IconThemeData(color: Colors.white,),
      colorScheme: scheme_basic(),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.black54),
        bodyText2: TextStyle(color: MyColor.basic[2]),
        overline:  TextStyle(fontSize: 15, color: MyColor.basic[2]),
        headline1: TextStyle(color: MyColor.basic[2]),
        headline2: TextStyle(color: MyColor.basic[2]),
        headline3: TextStyle(fontSize: 14,fontFamily: "RobotoMono", fontStyle: FontStyle.italic, color: Color(0xffeaeea2)),
        headline4: TextStyle(fontSize: 30,color: MyColor.basic[2]),
        headline5: TextStyle(color: Colors.white, fontSize: 16,),
        headline6: TextStyle(color: Colors.white),
        subtitle1: TextStyle(color: Colors.black54),
        subtitle2: TextStyle(color: Colors.redAccent, fontSize: 12),
        button: TextStyle(color: MyColor.basic[3]),
      ),
      textButtonTheme: TextButtonThemeData (
        style: ButtonStyle(
          alignment: Alignment.center,
          fixedSize: MaterialStateProperty.all(Size(140,35)),
          shape: MaterialStateProperty.all(StadiumBorder()),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(MyColor.basic[2]),
          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 14))
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(
          width: 1.5,
          color: MyColor.basic[1],
        ),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(
          width: 1.5,
          color: MyColor.basic[2],
        ),),
        /** labelStyleの色の変化がイマイチよく分からないのでColorSchemeのprimaryで設定 */
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide()
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: MyColor.basic[2],
        selectionColor: MyColor.basic[3].withAlpha(127),
        selectionHandleColor: MyColor.basic[3],
      ),
    );
  }
  static ColorScheme scheme_basic(){
    return ColorScheme(
      primary: MyColor.basic[1],
      secondary: MyColor.basic[5],  
      background: MyColor.basic[1], 
      brightness: Brightness.light, 
      primaryVariant: MyColor.basic[5], 
      secondaryVariant: MyColor.basic[5], 
      surface: MyColor.basic[5],
      error: MyColor.basic[3], 
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
      overline:  TextStyle(color: color),
      headline1: TextStyle(color: color),
      headline2: TextStyle(color: color),
      headline3: TextStyle(color: color),
      headline4: TextStyle(color: color),
      headline5: TextStyle(color: color),
      headline6: TextStyle(color: color),
      subtitle1: TextStyle(color: color),
      subtitle2: TextStyle(color: color),
      button: TextStyle(color: color),
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