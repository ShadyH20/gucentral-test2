import 'package:flutter/material.dart';
import "dart:convert";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

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
  static const quizzes = 'quizzes';
  static const examSched = 'exam_sched';

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
