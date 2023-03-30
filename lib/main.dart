import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gucentral/pages/evaluate/evaluate_a_course.dart';
import 'package:gucentral/utils/Theme.dart';
import 'package:gucentral/widgets/HomePageNavDrawer.dart';
import 'package:gucentral/widgets/MyColors.dart';
import "./pages/login_page.dart";
import './widgets/Requests.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Shared Prefs
  initiateSharedPreferences();

  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(statusBarColor: MyTheme.light));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [])
      .then(
    (_) {
      runApp(const MyApp());
    },
  );
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GUCentral',
      // home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        if (settings.name == '/evaluate') {
          // Cast the arguments to the correct
          // type: ScreenArguments.
          final args = settings.arguments as Map;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return EvaluateACourse(course: args);
            },
          );
        }
      },
      routes: {
        "/login": (context) => LoginPage(key: key),
        // "/evaluate": (context) => EvaluateACourse(key: key),
        "/home": (context) => HomePageNavDrawer(
              key: key,
              gpa: "",
            ),
        // "home_page": (context) => HomePageNavDrawer(
        //       key: key,
        //       gpa: "",
        //     )
        // "transcript_page": (context) => TranscriptPage(key: key),
      },
    );
  }
}
