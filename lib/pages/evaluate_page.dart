import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gucentral/pages/evaluate/evaluate_academics.dart';
import 'package:gucentral/pages/evaluate/evaluate_courses.dart';
import 'package:gucentral/widgets/Requests.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

import '../main.dart';
import '../widgets/MenuWidget.dart';
import '../widgets/MyColors.dart';

class EvaluatePage extends StatefulWidget {
  const EvaluatePage({super.key});

  @override
  State<EvaluatePage> createState() => _EvaluatePageState();
}

class _EvaluatePageState extends State<EvaluatePage> {
  // ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  int pageIndex = 0;

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = const [
      EvaluateCourses(),
      EvaluateAcademics()
      // Center(child: Text("Evaluate Academics")),
    ];
  }

  PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: evaluateAppBar(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        color: MyApp.isDarkMode.value
            ? MyColors.surface
            // const Color.fromARGB(255, 45, 45, 45)
            : const Color.fromARGB(255, 250, 250, 250),
        child: buildBottomNavBar(),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: pages,
      ),
      // SlideIndexedStack(
      //   // endSlideOffset: const Offset(0.0, 0),
      //   beginSlideOffset: Offset(pageIndex == 0 ? -1.0 : 1.0, 0.0),
      //   // curve: Curves.easeInOut,
      //   duration: const Duration(milliseconds: 250),
      //   // LazyLoadIndexedStack(
      //   index: pageIndex,
      //   children: const [
      //     EvaluateCourses(),
      //     Center(child: Text("Evaluate Academics"))
      //   ],
      // ),
    );
  }

  BottomNavigationBar buildBottomNavBar() {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: MyApp.isDarkMode.value ? MyColors.surface : null,
      // type: BottomNavigationBarType.shifting,
      unselectedItemColor: MyColors.secondary,
      selectedItemColor: MyColors.primary,
      // selectedLabelStyle: TextStyle(color: MyColors.primary),
      showUnselectedLabels: true,
      currentIndex: pageIndex,
      onTap: (value) {
        setState(() {
          pageIndex = value;
          pageController.animateToPage(value,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut);
        });
      },
      iconSize: 33,
      selectedIconTheme: const IconThemeData(size: 33),
      unselectedFontSize: 20,
      selectedFontSize: 20,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_outlined), label: "Courses"),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded), label: "Academics"),
      ],
    );
  }

  evaluateAppBar() {
    return AppBar(
      // systemOverlayStyle: SystemUiOverlayStyle(
      //     statusBarColor: MyColors.primary,
      //     statusBarIconBrightness: Brightness.dark,
      //     statusBarBrightness: Brightness.dark),
      elevation: 0,
      backgroundColor: MyColors.background,
      centerTitle: true,
      leadingWidth: 60.0,
      leading: const MenuWidget(),
      title: const Text("Evaluate"),
      actions: [
        IconButton(
          splashRadius: 15,
          // padding: EdgeInsets.symmetric(horizontal: 20.0),
          icon: SvgPicture.asset(
            "assets/images/refresh.svg",
            height: 24,
            color: MyColors.secondary,
          ),
          onPressed: () {
            refreshCurrentPage();
          },
        ),
        Container(
          width: 10,
        )
      ],
    );
  }

  refreshCurrentPage() async {
    print('Will sen notifiication in 5');
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          // channelKey: 'scheduled',
          channelKey: 'scheduled',
          roundedLargeIcon: true,
          // this is my asset for the sound: 'assets/sounds/notification.mp3'

          title: 'wait 5 seconds to show',
          body: 'now is 5 seconds later',
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
        ),
        schedule: NotificationInterval(
          interval: 5,
          timeZone: 'Africa/Cairo',
          preciseAlarm: true,
          // timezone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
        )
        // setState(() {
        //   if (pageIndex == 0) {
        //     pages[0] = EvaluateCourses();
        //     print('Refreshed Courses');
        //   } else {
        //     pages[1] = EvaluateAcademics();
        //     print('Refreshed Academics');
        //   }
        // }
        );
  }
}
