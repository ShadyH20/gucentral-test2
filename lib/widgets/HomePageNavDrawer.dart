import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gucentral/pages/evaluate_page.dart';
import 'package:gucentral/pages/home_page.dart';
import 'package:gucentral/pages/login_page.dart';
import 'package:gucentral/pages/courses_page.dart';
import 'package:gucentral/pages/schedule_page.dart';
import 'package:gucentral/pages/settings_page.dart';
import 'package:gucentral/pages/grades_page.dart';
import 'package:gucentral/pages/transcript_page.dart';
import 'package:gucentral/utils/SharedPrefs.dart';
// import 'package:gucentral/widgets/MyColors.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/MenuPage.dart';
import '../pages/attendance_page.dart';
import '../pages/map_page.dart';
import '../utils/local_auth_api.dart';
import 'MeduItemList.dart';
import 'Requests.dart';

class HomePageNavDrawer extends StatefulWidget {
  final String gpa;
  bool firstAccess = true;
  HomePageNavDrawer({Key? key, required this.gpa}) : super(key: key);
  @override
  State<HomePageNavDrawer> createState() => _HomePageNavDrawerState();
}

class _HomePageNavDrawerState extends State<HomePageNavDrawer> {
  // ignore: non_constant_identifier_names
  // late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  final GlobalKey<SchedulePageState> _scheduleKey =
      GlobalKey<SchedulePageState>();
  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();

  void callScheduleInit(bool val) {
    print("Calling schedule init from settings");
    _scheduleKey.currentState?.initializeSchedulePage();
  }

  void notifyHomePage() {
    print("Notifying home page");
    _homeKey.currentState!.getNumberOfQuizzesThisWeek();
  }

  late List<Widget> pages;

  late ZoomDrawerController _drawerController;
  GlobalKey transcriptKey = GlobalKey();

  int getIndex(MenuItemlist item) {
    switch (currentItem) {
      case MenuItems.home:
        return 0;
      case MenuItems.grades:
        return 1;
      case MenuItems.schedule:
        return 2;
      case MenuItems.settings:
        return 3;
      case MenuItems.grades:
        return 4;
      case MenuItems.transcript:
        return 5;
      case MenuItems.evaluate:
        return 6;
      case MenuItems.attendance:
        return 7;
      case MenuItems.map:
        return 8;

      // case MenuItems.login:
      //   return const LoginPage();
      default:
        return 0;
    }
  }

  late int selectedIndex;
  MenuItemlist currentItem =
      MenuItems.getItem(prefs.getString('default_page') ?? 'Home');

  bool loadingEverything = false;
  @override
  void initState() {
    super.initState();
    selectedIndex = getIndex(currentItem);
    pages = [
      HomePage(key: _homeKey),
      const CoursesPage(),
      SchedulePage(key: scheduleKey, notifyHomePage: notifyHomePage),
      SettingsPage(callScheduleInit: callScheduleInit),
      const GradesPage(),
      TranscriptPage(),
      const EvaluatePage(),
      const AttendancePage(),
      const MapPage(),
    ];
    _drawerController = ZoomDrawerController();

    // LOCK APP
    handleLockApp();
  }

  handleLockApp() async {
    if (prefs.getBool('lock') ?? false) {
      // display a blank bluured overlay on top of the app
      // to prevent the user from interacting with the app
      // until they authenticate
      // OverlayEntry overlayEntry = OverlayEntry(
      //   builder: (context) => Container(
      //     color: Colors.black.withOpacity(0.5),
      //     child: Center(
      //       child: CircularProgressIndicator(
      //         color: MyColors.secondary,
      //       ),
      //     ),
      //   ),
      // );
      // Overlay.of(context)!.insert(overlayEntry);

      var isAuthenticated = false;
      do {
        isAuthenticated = await LocalAuthApi.authenticate();
      } while (!isAuthenticated);

      // overlayEntry.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: ZoomDrawer(
          controller: ZoomDrawerController(),
          dragOffset: 120,
          // disableDragGesture: (prefs.getBool("loading") ?? true),
          openDragSensitivity: 300,
          mainScreenScale: 0,
          borderRadius: 0,
          angle: 0,

          // make a drawer style so that the drawer appears on top of the main screen
          drawerStyleBuilder:
              (context, animationValue, slideWidth, menuScreen, mainScreen) {
            double slide = slideWidth * animationValue;
            // print('Slide: $slide');
            return Stack(children: [
              Transform(
                transform: Matrix4.identity()..translate(slide),
                alignment: Alignment.center,
                child: mainScreen,
              ),
              slide == 0.0
                  ? Container()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: menuScreen,
                    ),
            ]);
          },
          // moveMenuScreen: true,
          menuScreenWidth: MediaQuery.of(context).size.width * 0.7,
          // menuScreenOverlayColor: MyColors.background,
          mainScreenTapClose: true,
          // menuBackgroundColor: Colors.transparent,
          // mainScreenOverlayColor: MyColors.background,
          slideWidth: MediaQuery.of(context).size.width * 0.7,
          mainScreen: (prefs.getBool("loading") ?? true)
              ? LazyLoadIndexedStack(
                  index: selectedIndex,
                  children: pages,
                )
              : IndexedStack(
                  index: selectedIndex,
                  children: pages,
                ),
          menuScreen: Builder(
            builder: (context) => MenuPage(
                key: menuPageKey,
                currentItem: currentItem,
                onSelectedItem: (item) async {
                  if (item == MenuItems.logout) {
                    // show confirmation dialog before logging out
                    bool logout = await buildConfirmationDialog(
                        context,
                        MyColors,
                        logoutRed,
                        Icons.logout,
                        "All your saved data will be lost!\ne.g. quizzes, deadlines, weights, etc...",
                        "Yes, Logout",
                        "No, I am staying");
                    if (!logout) return;

                    // Clear SharedPrefs
                    String theme =
                        prefs.getString('theme') ?? 'ThemeMode.system';
                    prefs.clear();
                    prefs.setString('theme', theme);
                    // Navigate to login page
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  }
                  if (!(prefs.getBool("loading")!)) {
                    setState(() {
                      currentItem = item;
                      selectedIndex = getIndex(item);
                    });
                    // ignore: use_build_context_synchronously
                  } else {
                    showSnackBar(context,
                        'Please wait for a moment for the app to load!');
                  }
                  ZoomDrawer.of(context)!.close() ?? false;
                }),
          ),
        ));
  }

  Color logoutRed = const Color.fromARGB(255, 223, 70, 67);

  buildLogoutDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 500,
        actionsAlignment: MainAxisAlignment.center,

        // Title
        icon: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: logoutRed.withOpacity(0.25),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.logout, color: logoutRed, size: 30),
        ),
        title: const Text("Are you sure?"),
        titleTextStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: MyColors.secondary),
        content: Text(
            "All your saved data will be lost!\ne.g. quizzes, deadlines, weights, etc...",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: MyColors.secondary.withOpacity(0.6))),
        backgroundColor: MyColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),

        // Actions
        actionsOverflowDirection: VerticalDirection.up,
        actionsOverflowButtonSpacing: 7,
        actions: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: TextButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text("No, I am staying",
                  style: TextStyle(
                    color: MyColors.secondary.withOpacity(0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: TextButton.styleFrom(
                backgroundColor: logoutRed,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Yes, Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
