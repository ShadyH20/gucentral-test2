import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTheme {
  static const Color orange = Color(0xFFF65F3E);
  static const Color orangeLight = Color(0xFFF66F51);
  static const Color darkGrey = Color(0xFF272932);
  static const Color yellow = Color(0xFFffc857);
  // static const Color secondaryVariant = Color(0xFF018786);
  static const Color light = Color(0xFFFFFFFF);
  // static const Color surface = Color(0xFFFAFAFA);
  static const Color error = Color(0xFFB00020);

  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: orange,
          fontFamily: 'Outfit',
        )),
    primaryColor: light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      // primary: Color.fromARGB(255, 223, 223, 223),
      primary: orange,
      primaryVariant: orangeLight,
      onPrimary: light,
      secondary: darkGrey,
      onSecondary: light,
      tertiary: yellow,
      error: error,
      onError: light,
      background: light,
      onBackground: darkGrey,
      surface: orange,
      onSurface: darkGrey,
    ),
    fontFamily: 'Outfit',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 60.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 246, 95, 62)),
      titleLarge: TextStyle(fontSize: 30.0),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Outfit'),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: light,
        primaryVariant: orangeLight,
        onPrimary: light,
        secondary: orange,
        onSecondary: darkGrey,
        tertiary: yellow,
        error: error,
        onError: light,
        background: darkGrey,
        onBackground: light,
        surface: orange,
        onSurface: light),
    fontFamily: 'Outfit',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 60.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 246, 95, 62)),
      titleLarge: TextStyle(fontSize: 30.0),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Outfit'),
    ),
  );
}
