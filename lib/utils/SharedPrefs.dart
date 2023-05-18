import 'package:flutter/material.dart';
import "package:gucentral/main.dart";
import "package:gucentral/pages/home_page.dart";
import "package:gucentral/pages/schedule_page.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

import "../pages/MenuPage.dart";

late SharedPreferences prefs;
Future<void> initiateSharedPreferences() async {
  prefs = await SharedPreferences.getInstance();
}

class SharedPrefs {
  static const username = 'username';
  static const password = 'password';
  static const gpa = 'gpa';
  static const name = 'name';
  static const firstName = 'first_name';
  static const id = 'id';
  static const courses = 'courses';
  static const schedule = 'schedule';
  static const major = 'major';
  static const quizzes = 'quizzes';
  static const midterm = 'midterm:';
  static const examSched = 'exam_sched';
  static const attendance = 'att:';
  static const grades = 'grades:';
  static const midterms = 'midterms';
  static const weights = 'weights:';
  static const notifications = 'notifications';
  static const notifRead = 'notifRead';
  static const firstAccess = 'first_access';

  static const dinoHi = 'dinoHi';

  static getString(String key) {
    return prefs.getString(key);
  }

  static setString(String key, String value) {
    prefs.setString(key, value);
  }

  static getBool(String key) {
    return prefs.getBool(key);
  }

  static setBool(String key, bool value) {
    prefs.setBool(key, value);
  }
}

final GlobalKey<MenuPageState> menuPageKey = GlobalKey();
final GlobalKey<MyAppState> mainKey = GlobalKey();
final GlobalKey<HomePageState> homeKey = GlobalKey();
final GlobalKey<SchedulePageState> scheduleKey = GlobalKey<SchedulePageState>();

// ignore: non_constant_identifier_names
ColorScheme MyColors = Theme.of(mainKey.currentContext!).colorScheme;

// Maps course code to course name
Map<String, String> courseMap = {};

// ignore: non_constant_identifier_names
buildConfirmationDialog(context, MyColors, Color mainColor, IconData iconData,
    String description, String confirmOption, String cancelOption) {
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
          color: mainColor.withOpacity(0.25),
        ),
        alignment: Alignment.center,
        child: Icon(iconData, color: mainColor, size: 30),
      ),
      title: const Text("Are you sure?"),
      titleTextStyle: TextStyle(
          fontSize: 25, fontWeight: FontWeight.bold, color: MyColors.secondary),
      content: Text(description,
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
            child: Text(cancelOption,
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
              backgroundColor: mainColor,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(confirmOption,
                style: const TextStyle(
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
