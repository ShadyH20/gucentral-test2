import 'package:flutter/material.dart';
import "dart:convert";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

import "HomePageNavDrawer.dart";

class Requests {
  static const backendURL =
      'https://gucentralbackend-production.up.railway.app';
  static Uri transcriptURL = Uri.parse('$backendURL/transcript');
  static Uri loginURL = Uri.parse('$backendURL/login');

  static Future<Map> getCreds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        prefs.setString('password', password);
        prefs.setString('gpa', res['gpa']);
        prefs.setString('name', res['name']);
        prefs.setString('id', res['id']);
      }
      return res;
    } on Exception {
      return null;
    }
  }
  // JsonCodec get(){

  // }

  static dynamic getTranscript(context) async {
    var out = await getCreds();
    print(out);
    out['year'] = '2020-2021';
    print(out);
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
