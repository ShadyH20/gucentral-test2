import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTheme {
  static const Color orange = Color(0xFFF65F3E);
  static const Color orangeLight = Color(0xFFF66F51);

  static const Color darkGrey = Color(0xFF272932);
  static const Color darkGrey2 = Color.fromARGB(255, 28, 29, 34);

  static const Color darkerGreyOld = Color.fromARGB(255, 16, 17, 17);
  static const Color darkerGrey = Color.fromARGB(255, 15, 15, 15);
  static const Color darkerGrey2 = Color(0xFF141518);

  static const Color yellow = Color(0xFFffc857);
  static const Color yellowDark = Color.fromARGB(255, 40, 40, 40);
  // static const Color secondaryVariant = Color(0xFF018786);
  static const Color light = Color(0xFFFFFFFF);
  // static const Color surface = Color(0xFFFAFAFA);
  static const Color error = Color(0xFFB00020);

  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: orange,
          fontFamily: 'Outfit',
        )),
    primaryColor: light,
    // hintColor: Colors.white12,
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
      surface: darkGrey,
      onSurface: Colors.black,
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
    // primaryColor: darkerGreyOld,
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: orange,
        primaryVariant: orangeLight,
        onPrimary: light,
        secondary: light,
        onSecondary: darkGrey,
        tertiary: yellow,
        surfaceVariant: darkGrey2,
        error: error,
        onError: light,
        background: darkerGrey2,
        onBackground: light,
        surface: darkGrey,
        onSurface: light),
    fontFamily: 'Outfit',
    appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: darkerGrey,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarContrastEnforced: false),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: light,
          fontFamily: 'Outfit',
        )),
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
