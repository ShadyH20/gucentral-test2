import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gucentral/utils/Theme.dart';
import 'package:gucentral/widgets/MyColors.dart';
import "./pages/login_page.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: MyTheme.light));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: [])
      .then(
    (_) => runApp(MyApp()),
  );
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
      themeMode: ThemeMode.light,
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
