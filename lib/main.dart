import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gucentral/pages/evaluate/evaluate_a_course.dart';
import 'package:gucentral/utils/SharedPrefs.dart';
import 'package:gucentral/utils/Theme.dart';
import 'package:gucentral/widgets/HomePageNavDrawer.dart';
import 'package:gucentral/widgets/MyColors.dart';
import "./pages/login_page.dart";
import './widgets/Requests.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Shared Prefs
  initiateSharedPreferences();

  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(statusBarColor: MyTheme.light));

  /// NOTIFICATIONS
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // statusBarColor: Colors.green,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemStatusBarContrastEnforced: false,
  ));
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

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final ValueNotifier<bool> isDarkMode =
      ValueNotifier(prefs.getBool('dark_mode') ?? false);

  // static ColorScheme MyColors = isDarkMode.value
  //     ? MyTheme.darkTheme.colorScheme
  //     : MyTheme.lightTheme.colorScheme;

  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // MyApp.MyColors = Theme.of(context).colorScheme;
    return ValueListenableBuilder<bool>(
      valueListenable: MyApp.isDarkMode,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          // builder:  (context, child) {
          //   return MediaQuery(
          //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //     child: child!,
          //   );
          // },
          key: mainKey,
          navigatorKey: MyApp.navigatorKey,
          title: 'GUCentral',
          // home: const LoginPage(),
          debugShowCheckedModeBanner: false,
          initialRoute: "/login",
          theme: isDarkMode
              ? MyTheme.lightTheme.copyWith(
                  primaryColor: MyTheme.darkTheme.colorScheme.background)
              : MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
            "/login": (context) => LoginPage(),
            // "/evaluate": (context) => EvaluateACourse(key: key),
            "/home": (context) => HomePageNavDrawer(
                  gpa: "",
                ),
            // "home_page": (context) => HomePageNavDrawer(
            //       key: key,
            //       gpa: "",
            //     )
            // "transcript_page": (context) => TranscriptPage(key: key),
          },
        );
      },
    );
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
        (route) =>
            (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }
}
