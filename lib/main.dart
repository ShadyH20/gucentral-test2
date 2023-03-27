import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:gucentral/utils/Theme.dart';
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
      Settings.init(cacheProvider: SharePreferenceCache()).then((_) {
        runApp(const MyApp());
      });
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
      initialRoute: "login_page",
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: {
        "login_page": (context) => LoginPage(key: key),
        // "home_page": (context) => HomePageNavDrawer(
        //       key: key,
        //       gpa: "",
        //     )
        // "transcript_page": (context) => TranscriptPage(key: key),
      },
    );
  }
}
