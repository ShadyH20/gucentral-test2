import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:gucentral/utils/weight_data.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gucentral/firebase_options.dart';
import 'package:gucentral/pages/evaluate/evaluate_a_course.dart';
import 'package:gucentral/utils/SharedPrefs.dart';
import 'package:gucentral/utils/Theme.dart';
import 'package:gucentral/widgets/HomePageNavDrawer.dart';
import 'package:gucentral/widgets/MyColors.dart';
import "./pages/login_page.dart";
import './widgets/Requests.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.title}');
    }
  });

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
          // the sound is in "assets\sounds\notification.mp3"
          soundSource: 'resource://raw/notification',
          // defaultColor: const Color(0xFF9D50DD),
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelGroupKey: 'scheduled_group',
          channelKey: 'scheduled',
          channelName: 'Scheduled notifications',
          channelDescription: 'Scheduled reminder notifications',
          groupKey: 'classes',
          enableVibration: true,
          playSound: true,
          // my asset is 'assets/sounds/notification.mp3'
          // soundSource: 'notification.mp3',
          // icon:  'resource://drawable/res_ic_gu_logo',
          // defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
        NotificationChannel(
          channelGroupKey: 'scheduled_group',
          channelKey: 'scheduled',
          channelName: 'Scheduled notifications',
          channelDescription: 'Scheduled reminder notifications',
          groupKey: 'quizzes',
          enableVibration: true,
          playSound: true,
          // my asset is 'assets/sounds/notification.mp3'
          // soundSource: 'notification.mp3',
          // icon:  'resource://drawable/res_ic_gu_logo',
          // defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  tz.initializeTimeZones();

  // setTestNotifications();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemStatusBarContrastEnforced: false,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]).then(
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
  static final ValueNotifier<ThemeMode> theme =
      ValueNotifier(toThemeMode(prefs.getString('theme')));

  static ValueNotifier<bool> isLoading =
      ValueNotifier(prefs.getBool("loading") ?? false);

  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  static toThemeMode(String? string) {
    switch (string) {
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    if (MyApp.theme.value == ThemeMode.system) {
      return MediaQuery.of(this).platformBrightness == Brightness.dark;
    }
    return MyApp.theme.value == ThemeMode.dark;
  }
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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: MyApp.theme,
      builder: (context, theme, child) {
        MyColors = Theme.of(context).colorScheme;
        return ChangeNotifierProvider(
          create: (context) => ProviderData(),
          child: MaterialApp(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: child!,
              );
            },
            key: mainKey,
            navigatorKey: MyApp.navigatorKey,
            title: 'GUCentral',
            // home: const LoginPage(),
            debugShowCheckedModeBanner: false,
            initialRoute: prefs.containsKey('username') ? "/home" : "/login",

            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            themeMode: theme,
            themeAnimationDuration: const Duration(milliseconds: 1000),
            themeAnimationCurve: Curves.easeInOutCubic,

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
              "/login": (context) => const LoginPage(),
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
          ),
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
