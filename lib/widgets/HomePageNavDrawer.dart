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
import 'package:gucentral/widgets/MyColors.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/MenuPage.dart';
import '../pages/attendance_page.dart';
import 'MeduItemList.dart';

class HomePageNavDrawer extends StatefulWidget {
  final String gpa;
  bool firstAccess = true;
  HomePageNavDrawer({Key? key, required this.gpa}) : super(key: key);
  @override
  State<HomePageNavDrawer> createState() => _HomePageNavDrawerState();
}

class _HomePageNavDrawerState extends State<HomePageNavDrawer> {
  final GlobalKey<SchedulePageState> _scheduleKey =
      GlobalKey<SchedulePageState>();

  void callScheduleInit(bool val) {
    // pages[getIndex(MenuItems.schedule)]
    print("HomeDrawer: In callScheduleInit");
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     // Call your method here
    _scheduleKey.currentState?.initializeSchedulePage();
    //   });
  }

  late List<Widget> pages;

  int selectedIndex = 0;
  MenuItemlist currentItem = MenuItems.home;

  late ZoomDrawerController _drawerController;
  GlobalKey transcriptKey = GlobalKey();

  int getIndex(MenuItemlist item) {
    switch (currentItem) {
      case MenuItems.home:
        return 0;
      case MenuItems.courses:
        return 1;
      case MenuItems.schedule:
        return 2;
      case MenuItems.settings:
        return 3;
      case MenuItems.grades:
        return 4;
      case MenuItems.transcript:
        {
          (pages[5] as TranscriptPage).hideGPA();
          return 5;
        }
      case MenuItems.evaluate:
        return 6;
      case MenuItems.attendance:
        return 7;

      // case MenuItems.login:
      //   return const LoginPage();
      // case MenuItems.map:
      //   return const LoginPage();
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    pages = [
      const HomePage(),
      const CoursesPage(),
      SchedulePage(key: _scheduleKey),
      SettingsPage(callScheduleInit: callScheduleInit),
      const GradesPage(),
      TranscriptPage(),
      const EvaluatePage(),
      const AttendancePage(),
    ];
    _drawerController = ZoomDrawerController();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async => false,
      child: ZoomDrawer(
        controller: ZoomDrawerController(),
        dragOffset: 120,
        openDragSensitivity: 300,
        mainScreenScale: 0,
        borderRadius: 0,
        angle: 0,
        menuScreenWidth: MediaQuery.of(context).size.width * 0.7,
        menuScreenOverlayColor: Colors.transparent,
        mainScreenTapClose: true,
        menuBackgroundColor: MyColors.primaryVariant,
        slideWidth: MediaQuery.of(context).size.width * 0.7,
        mainScreen: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
        menuScreen: Builder(
          builder: (context) => MenuPage(
              currentItem: currentItem,
              onSelectedItem: (item) async {
                if (item == MenuItems.login) {
                  // Clear SharedPrefs
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  // Navigate to login page
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                }
                setState(() {
                  currentItem = item;
                  selectedIndex = getIndex(item);
                });
                // ignore: use_build_context_synchronously
                ZoomDrawer.of(context)!.close() ?? false;
              }),
        ),
      ));
}
