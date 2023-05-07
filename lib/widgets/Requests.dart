import 'package:flutter/material.dart';
import "dart:convert";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "../main.dart";
import "../utils/SharedPrefs.dart";
import "HomePageNavDrawer.dart";
// import "MyColors.dart";

class Requests {
  static const backendURL =
      'https://gucentralbackend-production.up.railway.app';
  static Uri transcriptURL = Uri.parse('$backendURL/transcript');
  static Uri checkCredsURL = Uri.parse('$backendURL/checkCredentials');
  static Uri firstLoginURL = Uri.parse('$backendURL/firstLogin');
  static Uri loginURL = Uri.parse('$backendURL/login');

  static Uri coursesEvalURL = Uri.parse('$backendURL/coursesToEval');
  static Uri checkCourseEvalURL = Uri.parse('$backendURL/checkCourseEvaluated');
  static Uri evaluateCourseURL = Uri.parse('$backendURL/evaluateCourse');

  static Uri academicsEvalURL = Uri.parse('$backendURL/academicsToEval');
  static Uri checkAcademicEvalURL =
      Uri.parse('$backendURL/checkAcademicEvaluated');
  static Uri evaluateAcademicURL = Uri.parse('$backendURL/evaluateAcademic');

  static Uri examSchedURL = Uri.parse('$backendURL/examSched');
  static Uri attendanceURL = Uri.parse('$backendURL/attendance');
  static Uri gradesURL = Uri.parse('$backendURL/grades');
  static Uri notificationsURL = Uri.parse('$backendURL/notifications');

  // static SharedPreferences prefs = getPrefs();

  static Future<bool> checkCredentials(String username, String password) async {
    var body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      var response = await http.post(checkCredsURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      // print(response.toString());

      var login = jsonDecode(response.body);
      print(login);
      return login['success'];
    } on Exception catch (e) {
      print("Login exception $e");
      return false;
    }
  }

  static Map getCreds() {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var credentials = {};
    if (prefs.containsKey('username') && prefs.containsKey('password')) {
      credentials['username'] = prefs.getString('username');
      credentials['password'] = prefs.getString('password');
    }
    return credentials;
  }

  static Future<bool> firstLogin(username, password) async {
    var body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      var response = await http.post(firstLoginURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      var res = jsonDecode(response.body);
      var success = res['success'];
      if (success) {
        prefs.setString(SharedPrefs.username, username);
        prefs.setString(SharedPrefs.password, password);
        prefs.setString(SharedPrefs.id, res['id']);
        prefs.setString(SharedPrefs.name, res['name']);
        prefs.setString(
            SharedPrefs.firstName, res['name'].toString().split(' ')[0]);
        prefs.setString(SharedPrefs.major, res['major']);

        prefs.setBool(SharedPrefs.firstAccess, true);
      }
      return success;
    } catch (e) {
      print("Check Creds Exception: ${e.toString()}");
      return false;
    }
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
        prefs.setString('username', username);
        prefs.setString('password', password);
        prefs.setString('gpa', res['gpa']);
        prefs.setString('name', res['name']);
        prefs.setString('first_name', res['name'].toString().split(' ')[0]);
        prefs.setString('id', res['id']);
        prefs.setString('major', res['major']);
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

  static dynamic initializeEverything() async {
    if (prefs.getBool(SharedPrefs.firstAccess) ?? false) {
      prefs.setBool(SharedPrefs.firstAccess, false);
      prefs.setBool("loading", true);

      var body = jsonEncode(getCreds());

      try {
        var response = await http.post(loginURL, body: body, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

        var res = jsonDecode(response.body);
        if (res['success']) {
          prefs.setString('gpa', res['gpa']);
          prefs.setString('name', res['name']);
          prefs.setString('first_name', res['name'].toString().split(' ')[0]);
          prefs.setString('id', res['id']);
          var courses = jsonEncode(res['courses']);
          prefs.setString('courses', courses);
          var schedule = jsonEncode(res['schedule']);
          prefs.setString('schedule', schedule);
        }
        return res;
      } on Exception catch (e) {
        print("Login exception: ${e.toString()}");
        return null;
      }
    }
    return null;
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

  static List<Event> getQuizzes() {
    if (prefs.containsKey('quizzes')) {
      var list = jsonDecode(prefs.getString('quizzes')!);
      List<Event> quizzes = [];
      for (var quiz in list) {
        quizzes.add(Event.fromJson(quiz));
      }
      return quizzes;
    }

    return [];
  }

  static void updateQuizzes(List<Event> quizzes) {
    prefs.setString('quizzes', jsonEncode(quizzes));
  }

  static List<Event> getDeadlines() {
    if (prefs.containsKey('deadlines')) {
      var list = jsonDecode(prefs.getString('deadlines')!);
      List<Event> deadlines = [];
      for (var deadline in list) {
        deadlines.add(Event.fromJson(deadline));
      }
      return deadlines;
    }

    return [];
  }

  static void updateDeadlines(List<Event> deadlines) {
    prefs.setString('deadlines', jsonEncode(deadlines));
    print('updated deadlines to ${prefs.getString('deadlines')}');
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
      return {
        'success': false,
        'message': 'An error ocurred! Please try again.'
      };
    }
  }

  ////////////////////////////
  ///// EVALUATE COURSES /////
  ////////////////////////////
  static getCoursesToEval() async {
    var creds = getCreds();
    var body = jsonEncode(creds);

    try {
      var response = await http.post(coursesEvalURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      return jsonDecode(response.body);
    } on Exception catch (e) {
      print("Courses to eval exception $e");
      return null;
    }
  }

  static checkCourseEvaluated(String course) async {
    var out = getCreds();
    out['course'] = course;
    var body = jsonEncode(out);

    try {
      var response = await http.post(checkCourseEvalURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      return jsonDecode(response.body);
    } on Exception catch (e) {
      print("Courses to eval exception $e");
      return {
        'success': false,
        'message': 'An error ocurred! Please try again.'
      };
    }
  }

  static evaluateCourse(
      course, List<int> radio1vals, List radio2vals, String remark) async {
    var out = getCreds();
    out['course'] = course;
    out['radio1'] = radio1vals;
    out['radio2'] = radio2vals;
    out['remark'] = remark;
    var body = jsonEncode(out);

    try {
      var response = await http.post(evaluateCourseURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      return jsonDecode(response.body);
    } on Exception catch (e) {
      print("Evaluate course exception $e");
      return {
        'success': false,
        'message': 'An error ocurred! Please try again.'
      };
    }
  }
  ////////////////////////////

  ////////////////////////////
  //// EVALUATE ACADEMICS ////
  ////////////////////////////
  static getAcademicsToEval() async {
    var creds = getCreds();
    var body = jsonEncode(creds);

    try {
      var response = await http.post(academicsEvalURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      return jsonDecode(response.body);
    } on Exception catch (e) {
      print("Courses to eval exception $e");
      return null;
    }
  }

  static checkAcademicEvaluated(String academic) async {
    var out = getCreds();
    out['academic'] = academic;
    var body = jsonEncode(out);

    try {
      var response = await http.post(checkAcademicEvalURL,
          body: body,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      return jsonDecode(response.body);
    } on Exception catch (e) {
      print("Academics to eval exception $e");
      return {
        'success': false,
        'message': 'An error ocurred! Please try again.'
      };
    }
  }

  static evaluateAcademic(academic, List<int> radio1vals, String remark) async {
    var out = getCreds();
    out['academic'] = academic;
    out['radio1'] = radio1vals;
    out['remark'] = remark;
    var body = jsonEncode(out);

    try {
      var response = await http.post(evaluateAcademicURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      return jsonDecode(response.body);
    } on Exception catch (e) {
      print("Evaluate academic exception $e");
      return {
        'success': false,
        'message': 'An error ocurred! Please try again.'
      };
    }
  }
  ////////////////////

  static getExamSchedule() async {
    var creds = getCreds();
    var body = jsonEncode(creds);

    try {
      var response = await http.post(examSchedURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      var schedule = jsonDecode(response.body);
      if (schedule['success']) {
        prefs.setString(
            SharedPrefs.examSched, jsonEncode(schedule['exam_sched']));
      }
      return schedule;
    } on Exception catch (e) {
      print("Exam schedule exception $e");
      return {
        'success': false,
        'message': 'An error ocurred! Please try again.'
      };
    }
  }

  static void updateExams(List<Event> exams) {
    prefs.setString('exams', jsonEncode(exams));
  }

  static List<Event> getExamsSaved() {
    if (prefs.containsKey('exams')) {
      var list = jsonDecode(prefs.getString('exams')!);
      List<Event> exams = [];
      for (var exam in list) {
        exams.add(Event.fromJson(exam));
      }
      return exams;
    }

    return [];
  }

  static getAttendance(String course) async {
    var out = getCreds();
    out['course'] = course;
    var body = jsonEncode(out);

    try {
      var response = await http.post(attendanceURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      var attendance = jsonDecode(response.body);
      if (attendance['success']) {
        prefs.setString('${SharedPrefs.attendance}$course',
            jsonEncode(attendance['attendance']));
      }
      return attendance;
    } on Exception catch (e) {
      print("Attendance exception $e");
      return {
        'success': false,
        'message': 'An error ocurred! Please try again.'
      };
    }
  }

  static getAttendanceSaved(String course) {
    if (prefs.containsKey('${SharedPrefs.attendance}$course')) {
      return jsonDecode(prefs.getString('${SharedPrefs.attendance}$course')!);
    }
    return [];
  }

  static getNotifications() async {
    var creds = getCreds();
    var body = jsonEncode(creds);

    try {
      var response = await http.post(notificationsURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      var notifications = jsonDecode(response.body);

      // check set the notifications' read attribute
      setNotificationsRead(notifications);

      if (notifications['success']) {
        prefs.setString(SharedPrefs.notifications,
            jsonEncode(notifications['notifications']));
      }
      return notifications;
    } on Exception catch (e) {
      print("Notifications exception $e");
      return {
        'success': false,
        'message': 'An error ocurred! Please try again.'
      };
    }
  }

  static setNotificationsRead(notifications) {
    var readsSaved = getNotificationsSaved();
    for (var notification in notifications['notifications']) {
      for (var notificationSaved in readsSaved) {
        if (notification['id'] == notificationSaved['id']) {
          notification['read'] = notificationSaved['read'];
        }
      }
    }
  }

  static getNotificationsSaved() {
    if (prefs.containsKey(SharedPrefs.notifications)) {
      return jsonDecode(prefs.getString(SharedPrefs.notifications)!);
    }
    return [];
  }

  static getGrades(String course) async {
    var out = getCreds();
    out['course'] = course;
    var body = jsonEncode(out);

    try {
      var response = await http.post(gradesURL, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      var grades = jsonDecode(response.body);
      if (grades['success']) {
        prefs.setString(
            '${SharedPrefs.grades}$course', jsonEncode(grades['all_grades']));
      }
      return grades;
    } on Exception catch (e) {
      print("Grades exception $e");
      return {
        'success': false,
        'message': 'An error ocurred! Please try again.'
      };
    }
  }

  static getGradesSaved(String course) {
    if (prefs.containsKey('${SharedPrefs.grades}$course')) {
      return jsonDecode(prefs.getString('${SharedPrefs.grades}$course')!);
    }
    return [];
  }

  ////////////////////////////////
  //// END OF REQUEST METHODS ////
  ////////////////////////////////

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

//// EVENT CLASS ////
class Event implements Comparable<Event> {
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final Color color;
  final bool isAllDay;
  String recurrence;
  List<DateTime> recurrenceExceptionDates;
  String location;
  String slot;
  String group;

  Event({
    required this.title,
    required this.description,
    required this.start,
    required this.end,
    this.color = Colors.blue,
    this.isAllDay = false,
    this.recurrence = "",
    this.recurrenceExceptionDates = const [],
    this.location = "",
    this.slot = "0",
    this.group = "",
  });

  setRecurrenceExceptionDates(List<DateTime> dates) {
    recurrenceExceptionDates = dates;
  }

  @override
  String toString() => "$description: $title | Slot: $slot";

  @override
  bool operator ==(Object other) {
    if (other is Event) {
      return title == other.title &&
          description == other.description &&
          start.isAtSameMomentAs(other.start) &&
          end.isAtSameMomentAs(other.end) &&
          isAllDay == other.isAllDay &&
          location == other.location;
    }
    return false;
  }

  @override
  int compareTo(Event other) {
    debugPrint("IN COMPARE TO EVENT: $this & $other");
    if (title == other.title &&
        description == other.description &&
        start.isAtSameMomentAs(other.start) &&
        end.isAtSameMomentAs(other.end) &&
        isAllDay == other.isAllDay &&
        location == other.location) {
      debugPrint("THEY ARE EQUAL");
      return 0;
    } else {
      debugPrint("THEY ARE NOT EQUAL");
      return start.difference(other.start).inMinutes;
    }
  }

  Event.fromJson(Map<String, dynamic> json)
      : title = json['t'],
        description = json['d'],
        start = DateTime.parse(json['s']),
        end = DateTime.parse(json['e']),
        color = Color(json['c']),
        isAllDay = json['i'],
        recurrence = json['r'],
        recurrenceExceptionDates =
            (json['re'] as List).map((e) => DateTime.parse(e)).toList(),
        location = json['l'],
        slot = json['slot'],
        group = json['group'];

  Map<String, dynamic> toJson() {
    return {
      't': title,
      'd': description,
      's': start.toIso8601String(),
      'e': end.toIso8601String(),
      'c': color.value,
      'i': isAllDay,
      'r': recurrence,
      're': recurrenceExceptionDates.map((e) => e.toIso8601String()).toList(),
      'l': location,
      'slot': slot,
      'group': group,
    };
  }
}

void showSnackBar(BuildContext context, String text,
    {Duration duration = const Duration(seconds: 4)}) {
  final snackBar = SnackBar(
    duration: duration,
    behavior: SnackBarBehavior.floating,
    elevation: 7,
    backgroundColor: MyApp.isDarkMode.value
        ? Theme.of(context).colorScheme.surface
        : Color.fromARGB(255, 113, 118, 121),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    width: MediaQuery.of(context).size.width * 0.8,
    content: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        // color: Theme.of(context).colorScheme.secondary,
        color: Colors.white,
      ),
    ),
    showCloseIcon: true,
    closeIconColor: MyColors.background,
  );
  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
