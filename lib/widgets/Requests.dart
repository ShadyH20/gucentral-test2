import 'package:flutter/material.dart';
import "dart:convert";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "HomePageNavDrawer.dart";

late SharedPreferences prefs;
Future<void> initiateSharedPreferences() async {
  prefs = await SharedPreferences.getInstance();
}

class Requests {
  static const backendURL =
      'https://gucentralbackend-production.up.railway.app';
  static Uri transcriptURL = Uri.parse('$backendURL/transcript');
  static Uri loginURL = Uri.parse('$backendURL/login');

  // static SharedPreferences prefs = getPrefs();

  static Map getCreds() {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var credentials = {};
    if (prefs.containsKey('username') && prefs.containsKey('password')) {
      credentials['username'] = prefs.getString('username');
      credentials['password'] = prefs.getString('password');
    }
    return credentials;
  }

  static dynamic login(context, username, password) async {
    var body = jsonEncode({
      'username': username,
      'password': password,
    });
    // print("WILL SEND REQUEST NAAWW");

    try {
      var response = await http.post(loginURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      var res = jsonDecode(response.body);
      if (res['success']) {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        prefs.setString('password', password);
        prefs.setString('gpa', res['gpa']);
        print("Last option from res: ${res['last_option']}");
        prefs.setString('last_option', res['last_option']);
        prefs.setString('name', res['name']);
        prefs.setString('id', res['id']);
        var courses = jsonEncode(res['courses']);
        prefs.setString('courses', courses);
        var schedule = jsonEncode(res['schedule']);
        prefs.setString('schedule', schedule);
      }
      return res;
    } on Exception catch (e) {
      print("exceptionn: ${e.toString()}");
      return null;
    }
  }

  static dynamic getIdName() {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return [prefs.getString('id'), prefs.getString('name')];
  }

  static dynamic getUsernameId() {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return [prefs.getString('username'), prefs.getString('id')];
  }

  static dynamic getCourses() {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('courses')!);
  }

  static dynamic getSchedule() {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('schedule')!);
  }

  static dynamic getTranscript(context, year) async {
    var out = getCreds();
    out['year'] = year;
    var body = jsonEncode(out);

    try {
      var response = await http.post(transcriptURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      return jsonDecode(response.body);
    } on Exception catch (e) {
      print("transcript exception $e");
      return null;
    }
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('An Error Occurred! Check Credentials And Try Again.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Event implements Comparable<Event> {
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final Color color;
  final bool isAllDay;
  String recurrence;
  String location;

  Event({
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    required this.color,
    required this.isAllDay,
    this.recurrence = "",
    this.location = "",
  });

  @override
  String toString() => "$description: $title";

  @override
  int compareTo(Event other) {
    if (title == other.title &&
        description == other.description &&
        start == other.start &&
        end == other.end &&
        isAllDay == other.isAllDay &&
        location == other.location) {
      return 0;
    } else {
      return start.difference(other.start).inMinutes;
    }
  }
}
