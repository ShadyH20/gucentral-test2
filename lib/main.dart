import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

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
          // defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
        NotificationChannel(
          channelGroupKey: 'scheduled_group',
          channelKey: 'scheduled',
          channelName: 'Scheduled notifications',
          channelDescription: 'Scheduled reminder notifications',
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

  setTestNotifications();

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

Future<void> setTestNotifications() async {
  //get local time zone
  String timeZoneName =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();
  print(timeZoneName);
  AwesomeNotifications().cancelAll();

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: -1,
      channelKey: 'scheduled',
      title: 'Lab',
      body: '3 May, 8:15 AM - Network & Media Lab, Lab in C6.209',
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
    ),
    schedule: NotificationCalendar(
        preciseAlarm: true,
        hour: 1,
        minute: 55,
        // second: 0,
        // millisecond: 0,
        allowWhileIdle: true,
        day: 3,
        month: 5,
        year: 2023,
        timeZone: timeZoneName),
  );
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: -1,
      channelKey: 'scheduled',
      title: 'Lab',
      body: '3 May, 8:15 AM - Network & Media Lab, Lab in C6.209',
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
    ),
    schedule: NotificationCalendar(
        preciseAlarm: true,
        hour: 8,
        minute: 0,
        // second: 0,
        // millisecond: 0,
        allowWhileIdle: true,
        day: 3,
        month: 5,
        year: 2023,
        timeZone: timeZoneName),
  );
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: -1,
      channelKey: 'scheduled',
      title: 'Tutorial',
      body: '3 May, 10:00 AM - Data Bases II, Tutorial in C3.104',
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
    ),
    schedule: NotificationCalendar(
        preciseAlarm: true,
        hour: 9,
        minute: 45,
        // second: 0,
        // millisecond: 0,
        allowWhileIdle: true,
        day: 3,
        month: 5,
        year: 2023,
        timeZone: timeZoneName),
  );
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: -1,
      channelKey: 'scheduled',
      title: 'Lab',
      body: '3 May, 11:45 AM - Computer System Architecture, Lab in C7.203',
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
    ),
    schedule: NotificationCalendar(
        preciseAlarm: true,
        hour: 11,
        minute: 30,
        // second: 0,
        // millisecond: 0,
        allowWhileIdle: true,
        day: 3,
        month: 5,
        year: 2023,
        timeZone: timeZoneName),
  );
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: -1,
      channelKey: 'scheduled',
      title: 'Lecture',
      body: '3 May, 1:45 PM - Operating Systems, Lecture in H18',
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
    ),
    schedule: NotificationCalendar(
        preciseAlarm: true,
        hour: 13,
        minute: 30,
        // second: 0,
        // millisecond: 0,
        allowWhileIdle: true,
        day: 3,
        month: 5,
        year: 2023,
        timeZone: timeZoneName),
  );
  List nots = await AwesomeNotifications().listScheduledNotifications();
  print(nots.length);
  print(nots);
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
          initialRoute: prefs.containsKey('username') ? "/home" : "/login",
          
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
