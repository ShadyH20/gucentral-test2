import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gucentral/widgets/MyColors.dart';
import 'package:gucentral/widgets/Requests.dart';

import '../widgets/MeduItemList.dart';

class MenuPage extends StatefulWidget {
  MenuItemlist currentItem;
  ValueChanged<MenuItemlist> onSelecteItem;
  MenuPage({super.key, required this.currentItem, required this.onSelecteItem});

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
    print(idName);
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          backgroundColor: MyColors.primary,
          body: Container(
            // color: MyColors.accent,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: SizedBox(
                    // color: MyColors.accent,
                    width: 200,
                    child: Wrap(
                      spacing: 0,
                      children: [
                        ...MenuItems.all.map(buildMenuItem).toList(),
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
                            BoxShadow(
                                color: MyColors.background,
                                offset: Offset(-30, 30)),
                            BoxShadow(
                                color: MyColors.secondary,
                                offset: Offset(30, 30))
                          ],
                          color: MyColors.secondary,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(25),
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
      print(idName);
      return Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 60, spreadRadius: 10)
        ]),
        child: Column(
          children: [
            ListTile(
              dense: false,
              contentPadding: const EdgeInsets.only(top: 20, bottom: 10),
              horizontalTitleGap: 10.0,
              minVerticalPadding: 10,
              leading: CircleAvatar(
                radius: 28,
                foregroundColor: MyColors.background,
                backgroundColor: MyColors.secondary,
                child: Text(
                  idName[1][0] ?? "",
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: FractionalOffset.centerLeft,
                  child: Text(
                    idName[1].toString().split(" ").sublist(0, 2).join(" "),
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              subtitle: Text(
                idName[0],
                style: const TextStyle(
                  color: MyColors.background, fontSize: 16,
                  // fontWeight:
                  // decoration: TextDecoration.underline,
                ),
              ),
              // ),
            ),
            const Divider(
              color: MyColors.background,
              thickness: 3,
            ),
            const SizedBox(
              height: 25,
            )
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
      return ListTileTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        selectedColor: MyColors.background,
        textColor: MyColors.background.withOpacity(0.5),
        iconColor: MyColors.background.withOpacity(0.5),
        child: ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: 1),
          // selectedTileColor: Colors.white,
          // textColor: MyColors.background.withOpacity(0.5),
          selected: widget.currentItem == item,
          minLeadingWidth: 0,
          leading: item.icon != null ? Icon(item.icon) : null,
          title: Text(
            item.title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontFamily: "Outfit",
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => widget.onSelecteItem(item),
        ),
      );
    }
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
  static const seperator = MenuItemlist('Seperator');
  static final all = <MenuItemlist>[
    profile,
    home,
    grades,
    courses,
    schedule,
    transcript,
    map,
    seperator,
    settings,
    login
  ];
}
