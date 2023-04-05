import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gucentral/widgets/MyColors.dart';
import 'package:gucentral/widgets/Requests.dart';

import '../widgets/MeduItemList.dart';

class MenuPage extends StatefulWidget {
  MenuItemlist currentItem;
  ValueChanged<MenuItemlist> onSelectedItem;
  MenuPage(
      {super.key, required this.currentItem, required this.onSelectedItem});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<dynamic> idName = [];

  _MenuPageState() {
    getIdName();
  }
  getIdName() async {
    var out = await Requests.getIdName();
    setState(() {
      idName = out;
    });
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          backgroundColor: MyColors.background,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 255, 165, 87),
                    MyColors.primaryVariant,
                    MyColors.primary
                  ]),
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(25),
              ),
            ),
            // color: MyColors.accent,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
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
                          color: MyColors.background,
                          thickness: 3,
                        ),
                        buildMenuItem(MenuItems.settings),
                        buildMenuItem(MenuItems.login),
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
                      decoration: const BoxDecoration(
                          boxShadow: [
                            // BoxShadow(
                            //     color: MyColors.background,
                            //     offset: Offset(-30, 30)),
                            // BoxShadow(
                            //     color: MyColors.secondary,
                            //     offset: Offset(30, 30))
                          ],
                          color: MyColors.secondary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          )),
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
        ),
      );
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
              contentPadding: const EdgeInsets.only(top: 20, bottom: 10),
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
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: FractionalOffset.centerLeft,
                  child: Text(
                    idName[1].toString().split(" ").sublist(0, 2).join(" "),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF0F0F0)),
                  ),
                ),
              ),
              subtitle: Text(
                idName[0],
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
          color: MyColors.background,
          thickness: 3,
        ),
      ]);
    } else {
      bool isComingSoon = comingSoon(item.title);
      return ListTileTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        selectedColor: MyColors.background,
        textColor: MyColors.background.withOpacity(0.5),
        iconColor: MyColors.background.withOpacity(0.5),
        child: ListTile(
          enabled: !isComingSoon,
          // i need the trailing to shrink to accomodate for the width of the title
          // how can i do that? answer in the next comment
          // hello? answer? anyone?
          // i want to shrink the trailing widget so that the title does not overflow

          dense: true,
          visualDensity: const VisualDensity(vertical: 1),
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
                  fontWeight: FontWeight.bold,
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
                            color: MyColors.background.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            fontSize: 11),
                      ),
                    )
                  : Container(),
            ],
          ),
          onTap: () => widget.onSelectedItem(item),
        ),
      );
    }
  }

  bool comingSoon(String title) {
    return title == 'Courses' || title == 'Grades' || title == 'Map';
  }
}

class MenuItems {
  static const profile = MenuItemlist('Profile');
  static const login = MenuItemlist('Logout', Icons.logout_outlined);
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
    grades,
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
}
