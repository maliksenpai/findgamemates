import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomThemeData {
  static Color accentColor = const Color(0xfff6e192);
  static Color primaryColor = const Color(0xff75a3e7);
  static Color primaryAccentColor = const Color(0xff9bc4f9);
  static Color backgroundColor = const Color(0xffeff3f7);
  static Color cardColor = const Color(0xffadf7b6);

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
    primaryColorDark: primaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          primary: accentColor,
          textStyle: const TextStyle(color: Colors.white)),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: accentColor,
    ),
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
    textTheme: GoogleFonts.openSansTextTheme(),
    tabBarTheme: TabBarTheme(
      labelColor: cardColor,
    ),
  );

  final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      buttonTheme: ButtonThemeData(
        buttonColor: accentColor,
      ),
      textTheme: const TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
      ).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      primaryColor: primaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: accentColor,
            textStyle: const TextStyle(color: Colors.white)),
      ),
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
        barBackgroundColor: Colors.black,
      )
      //textTheme: GoogleFonts.openSansTextTheme()
      );
}
