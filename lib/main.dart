import 'package:flutter/material.dart';
import "./pages/login_page.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "login_page",
        theme: ThemeData(
          // Define the default brightness and colors.
          // brightness: Brightness.dark,
          primaryColor: Color.fromARGB(255, 246, 95, 62),

          // Define the default font family.
          fontFamily: 'Outfit',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 246, 95, 62)),
            titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Outfit'),
          ),
        ),
        routes: {
          "login_page": (context) => LoginPage(key: key),
        });
  }
}
