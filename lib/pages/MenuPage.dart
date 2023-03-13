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
                    // width: 200,
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
        alignment: AlignmentDirectional.center,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: MyColors.primaryVariant,
        ),
        child: ListTile(
          isThreeLine: true,
          contentPadding:
              const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),

          horizontalTitleGap: 10.0,
          title: Align(
            heightFactor: 1.1,
            alignment: FractionalOffset.centerLeft,
            child: CircleAvatar(
              radius: 35,
              foregroundColor: MyColors.background,
              backgroundColor: MyColors.secondary,
              child: Text(
                idName[1][0] ?? "",
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          // title: Text(
          //   idName[1].toString().split(" ").sublist(0, 2).join(" "),
          //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          subtitle: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text.rich(
              maxLines: 2,
              TextSpan(
                text:
                    "${idName[1].toString().split(" ").sublist(0, 2).join(" ")}\n",
                style: const TextStyle(
                    overflow: TextOverflow.fade,
                    height: 1.4,
                    color: MyColors.background,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text: idName[0],
                    style: const TextStyle(
                        // color: MyColors.background,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          // : Text(
          //   idName[0],
          //   style: const TextStyle(
          //     color: MyColors.background,
          //     // decoration: TextDecoration.underline,
          //   ),
          // ),
        ),
      );
    }
    if (item.title == "Seperator") {
      return Column(children: [
        Container(height: 40),
        const Divider(
          indent: 30,
          endIndent: 35,
          color: MyColors.background,
          thickness: 4,
        ),
      ]);
    } else {
      return ListTileTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
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
