import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gucentral/pages/home_page.dart';
import 'package:gucentral/pages/login_page.dart';
import 'package:gucentral/pages/courses_page.dart';
import 'package:gucentral/pages/schedule_page.dart';
import 'package:gucentral/pages/settings_page.dart';
import 'package:gucentral/pages/grades_page.dart';
import 'package:gucentral/pages/transcript_page.dart';
import 'package:gucentral/widgets/MyColors.dart';

import '../pages/MenuPage.dart';
import 'MeduItemList.dart';

class HomePageNavDrawer extends StatefulWidget {
  final String gpa;
  const HomePageNavDrawer({super.key, required this.gpa});
  @override
  State<HomePageNavDrawer> createState() => _HomePageNavDrawerState();
}

class _HomePageNavDrawerState extends State<HomePageNavDrawer> {
  MenuItemlist currentItem = MenuItems.transcript;

  late TranscriptPage transcriptPage;
  late HomePage homePage;
  late CoursesPage coursesPage;
  late SchedulePage schedulePage;
  late SettingsPage settingsPage;
  late GradesPage gradesPage;

  @override
  void initState() {
    super.initState();
    // Create all pages here!
    transcriptPage = TranscriptPage(gpa: widget.gpa);
    homePage = const HomePage();
    coursesPage = const CoursesPage();
    schedulePage = const SchedulePage();
    settingsPage = const SettingsPage();
    gradesPage = const GradesPage();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async => false,
      child: ZoomDrawer(
        dragOffset: 120,
        openDragSensitivity: 300,
        mainScreenScale: 0,
        borderRadius: 25,
        angle: 0,
        menuScreenWidth: 290,
        mainScreenTapClose: true,
        menuBackgroundColor: MyColors.primary,
        slideWidth: MediaQuery.of(context).size.width * 0.7,
        mainScreen: getScreen(),
        menuScreen: Builder(
          builder: (context) => MenuPage(
              currentItem: currentItem,
              onSelecteItem: (item) {
                setState(() => currentItem = item);
                ZoomDrawer.of(context)!.close();
              }),
        ),
      ));
  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.home:
        return homePage;
      case MenuItems.grades:
        return gradesPage;
      case MenuItems.courses:
        return coursesPage;
      case MenuItems.schedule:
        return schedulePage;
      case MenuItems.login:
        return const LoginPage();
      case MenuItems.transcript:
        return transcriptPage;
      case MenuItems.map:
        return const LoginPage();
      case MenuItems.settings:
        return settingsPage;
      default:
        return homePage;
    }
  }
}
