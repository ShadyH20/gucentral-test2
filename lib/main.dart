import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gucentral/pages/transcript_page.dart';
import 'package:gucentral/widgets/HomePageNavDrawer.dart';
import 'package:gucentral/widgets/MyColors.dart';
import "./pages/login_page.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: []).then(
    (_) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      // initialRoute: "login_page",
      initialRoute: "login_page",
      theme: ThemeData(
        // Define the default brightness and colors.
        // brightness: Brightness.dark,
        // primaryColor: const Color.fromARGB(255, 246, 95, 62),
        primaryColor: MyColors.background,

        // Define the default font family.
        fontFamily: 'Outfit',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 60.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 246, 95, 62)),
          titleLarge: TextStyle(fontSize: 30.0),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Outfit'),
        ),
      ),
      routes: {
        "login_page": (context) => LoginPage(key: key),
        "home_page": (context) => HomePageNavDrawer(key: key)
        // "transcript_page": (context) => TranscriptPage(key: key),
      },
    );
  }
}
