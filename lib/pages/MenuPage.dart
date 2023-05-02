import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gucentral/widgets/MyColors.dart';
import 'package:gucentral/widgets/Requests.dart';

import '../main.dart';
import '../utils/SharedPrefs.dart';
import '../widgets/MeduItemList.dart';

class MenuPage extends StatefulWidget {
  MenuItemlist currentItem;
  ValueChanged<MenuItemlist> onSelectedItem;
  MenuPage(
      {super.key, required this.currentItem, required this.onSelectedItem});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  late List<String?> idName;

  @override
  void initState() {
    super.initState();
    getIdName();
  }

  getIdName() {
    var out = Requests.getIdName();
    setState(() {
      idName = out;
    });
  }

  // ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      // extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          // border: Border.all(color: MyColors.primary, width: 0.5),
          boxShadow: MyApp.isDarkMode.value
              ? [
                  BoxShadow(
                    color: MyColors.primary.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0.5, 0), // changes position of shadow
                  ),
                ]
              : null,
          gradient: MyApp.isDarkMode.value
              ? null
              // LinearGradient(
              //     // begin: Alignment(-1.7, 0.2),
              //     // end: Alignment(1.43, -0.2),
              //     begin: Alignment(0.8, 0.8),
              //     end: Alignment(-1, -1.4),
              //     // end: Alignment(1.7, -0.4),
              //     // colors: [Colors.black, Color(0xFF303030)])
              //     colors: [Colors.black, MyColors.primaryVariant])
              // // colors: [
              // // MyColors.surface, MyColors.surface
              // // Colors.black,
              // // MyColors.primary,
              // // MyColors.primaryVariant
              // // ])
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                      const Color.fromARGB(255, 255, 165, 87),
                      MyColors.primaryVariant,
                      MyColors.primary
                    ]),
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(25),
          ),
          color:
              // Color.fromARGB(255, 21, 24, 27)
              // Color.fromARGB(255, 17, 18, 19)
              MyApp.isDarkMode.value ? Colors.grey[900] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: kToolbarHeight - 50 / 3),
            Expanded(
              flex: 9,
              child: Padding(
                // color: MyColors.accent,
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    buildMenuItem(MenuItems.profile),
                    const Spacer(),
                    ...MenuItems.all.map(buildMenuItem).toList(),
                    const Spacer(),
                    const Divider(
                      color: Colors.white,
                      thickness: 3,
                    ),
                    buildMenuItem(MenuItems.settings),
                    buildMenuItem(MenuItems.logout),
                    const Spacer(flex: 2)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  // height: 150,
                  decoration: BoxDecoration(
                      color: MyApp.isDarkMode.value
                          ? Color.fromARGB(255, 18, 18, 18)
                          // ? Colors.black
                          // ? MyColors.surface
                          : MyColors.surface,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(25),
                      ),
                      boxShadow: MyApp.isDarkMode.value
                          ? [
                              const BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 0,
                                  spreadRadius: 0,
                                  offset: Offset(0, -0.9))
                            ]
                          : null),

                  padding: const EdgeInsets.all(42),
                  width: double.infinity,
                  child: SvgPicture.asset(
                    "assets/images/main-logo.svg",
                    // height: 70,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(MenuItemlist item) {
    if (item.title == "Profile") {
      return Container(
        // decoration: const BoxDecoration(boxShadow: [
        //   BoxShadow(color: Colors.black26, blurRadius: 70, spreadRadius: 07)
        // ]),
        child: Column(
          children: [
            ListTile(
              dense: false,
              contentPadding: const EdgeInsets.only(top: 0),
              horizontalTitleGap: 10.0,
              minVerticalPadding: 10,

              leading: SvgPicture.asset(
                "assets/images/profile.svg",
                height: 50,
              ),
              // CircleAvatar(
              //   radius: 28,
              //   foregroundColor: MyColors.background,
              //   backgroundColor: MyColors.secondary,
              //   child: Text(
              //     idName[1][0] ?? "",
              //     style: const TextStyle(fontSize: 25),
              //   ),
              // ),
              title: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: AutoSizeText(
                  "${idName[1]?.split(" ")[0]} ${idName[1]?.split(" ")[1]}",
                  maxLines: 1,
                  minFontSize: 10,
                  maxFontSize: 20,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF0F0F0)),
                ),
              ),
              subtitle: Text(
                idName[0] ?? '#ERROR',
                style: const TextStyle(
                  color: Color(0xFFF0F0F0),
                  fontSize: 16,
                  // fontWeight: FontWeight.bold
                  // decoration: TextDecoration.underline,
                ),
              ),
              // ),
            ),
          ],
        ),
      );
    }
    if (item.title == "Seperator") {
      return Column(children: [
        Container(height: 40),
        const Divider(
          color: Colors.white,
          thickness: 3,
        ),
      ]);
    } else {
      bool isComingSoon = comingSoon(item.title);
      return ListTileTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        selectedColor: Colors.white,
        textColor: Colors.white.withOpacity(0.5),
        iconColor: Colors.white.withOpacity(0.5),
        // change disabled tiles color

        child: ListTile(
          // enabled: !isComingSoon,
          dense: true,
          visualDensity: const VisualDensity(vertical: 0.2),
          // selectedTileColor: Colors.white,
          // textColor: MyColors.background.withOpacity(0.5),
          selected: widget.currentItem == item,
          minLeadingWidth: 0,
          leading: item.icon != null ? Icon(item.icon) : null,
          title: Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.title,
                maxLines: 1,
                // overflow: TextOverflow,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              isComingSoon
                  ? Positioned(
                      bottom: 10,
                      // top: 0,
                      right: 0,
                      child: Text(
                        'Coming Soon',
                        maxLines: 1,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            fontSize: 11),
                      ),
                    )
                  : Container(),
            ],
          ),
          onTap: () {
            if (isComingSoon) return;
            widget.onSelectedItem(item);
          },
        ),
      );
    }
  }

  bool comingSoon(String title) {
    return title == 'Grades' || title == 'Map';
  }
}

class MenuItems {
  static const profile = MenuItemlist('Profile');
  static const logout = MenuItemlist('Logout', Icons.logout_outlined);
  static const transcript = MenuItemlist('Transcript');
  static const home = MenuItemlist('Home');
  static const grades = MenuItemlist('Grades');
  static const courses = MenuItemlist('Courses');
  static const schedule = MenuItemlist('Schedule');
  static const map = MenuItemlist('Map');
  static const settings = MenuItemlist('Settings', Icons.settings);
  static const evaluate = MenuItemlist('Evaluate');
  static const attendance = MenuItemlist('Attendance');
  static const seperator = MenuItemlist('Seperator');
  static final all = <MenuItemlist>[
    // profile,
    home,
    // grades,
    courses,
    schedule,
    attendance,
    transcript,
    evaluate,
    map,
    // seperator,
    // settings,
    // login
  ];

  static MenuItemlist getItem(String s) {
    switch (s) {
      case 'Home':
        return home;
      case 'Transcript':
        return transcript;
      case 'Grades':
        return grades;
      case 'Courses':
        return courses;
      case 'Schedule':
        return schedule;
      case 'Map':
        return map;
      case 'Settings':
        return settings;
      case 'Evaluate':
        return evaluate;
      case 'Attendance':
        return attendance;
      default:
        return home;
    }
  }
}
