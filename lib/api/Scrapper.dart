// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:html/parser.dart' as parser;
import 'package:ntlm/ntlm.dart';
import 'package:universal_html/html.dart';
// import 'package:universal_html/html.dart';
import 'package:webdriver/async_io.dart';

import '../utils/SharedPrefs.dart';

const portal_url = 'https://student.guc.edu.eg';
const schedule_url =
    'https://student.guc.edu.eg/Web/Student/Schedule/GroupSchedule.aspx';
const courses_url = 'https://cms.guc.edu.eg/apps/student/HomePageStn.aspx';
const transcriptUrl =
    "https://student.guc.edu.eg/external/student/grade/Transcript.aspx";
const evalCourses =
    "https://student.guc.edu.eg/External/Student/Course/EvaluateCourse.aspx";
const evalAcademics =
    "https://student.guc.edu.eg/external/student/staff/EvaluateStaff.aspx";
const exams_url = "https://apps.guc.edu.eg//student_ext/Exam/ViewExamSeat.aspx";
const attendance_url =
    "https://student.guc.edu.eg/External/LSI/EAACMS/SACMM/ClassAttendance_ViewStudentAttendance.aspx";
const notifications_url =
    'https://apps.guc.edu.eg/student_ext/Messaging/Notifications.aspx';
const grades_url = "https://apps.guc.edu.eg//student_ext/Grade/CheckGrade.aspx";

class Scrapper {
  static getUsername() {
    return prefs.getString('username');
  }

  static getPassword() {
    return prefs.getString('password');
  }

  static client() {
    var username = Scrapper.getUsername();
    var password = Scrapper.getPassword();
    NTLMClient client = NTLMClient(
      domain: "",
      workstation: "LAPTOP",
      username: username,
      password: password,
    );

    return client;
  }

  static get_url_with_v(String url) async {
    /*
    r = requests.get(url, auth=HttpNtlmAuth(self.username, self.password))
        soup = BeautifulSoup(r.content, 'html.parser')
        payload = soup.find_all('script')
        payload = payload[1].text

        # e.g. sTo('QBL821205')
        payload = payload[payload.find("(")+2: payload.find(")")-1]
        return f"{url}?v={payload}"
        */

    NTLMClient client = Scrapper.client();

    var res = await client.get(Uri.parse(url));
    if (res.statusCode != 200) {
      return url;
    }
    var doc = parser.parse(res.body);

    var payload = doc.getElementsByTagName("script")[1].innerHtml;
    payload =
        payload.substring(payload.indexOf("(") + 2, payload.indexOf(")") - 1);
    return "$url?v=$payload";
  }

  /*
  resp = requests.get(self.get_url_with_v(notifications_url),
                            auth=HttpNtlmAuth(self.username, self.password))

  if resp.status_code != 200:
      print("An Error Occurred. Check Credentials And Try Again.")
      return {'notifications': [], 'success': False}

  html = HTMLParser(resp.text)
  all_nots = html.css("#gv_notifications tr")[1:]
  result = []

  for notification in all_nots:
      title = notification.css("td")[1].text()
      course_code = title.split(" - ")[-2].replace(" ", "")
      title = title[: title.find(" [")]

      date = notification.css("td")[2].text()

      entire_message = notification.css_first(
          "input").attributes['data-body']
      
      message_data = entire_message[:entire_message.find("------------------------------")].replace('<br />', '')
      department = entire_message.split("<br />------------------------------")[1].split("<br />")[2]
      sender = entire_message.split(
          "<br />------------------------------")[1].split("<br />")[1]
      sender = sender.replace(" \n", "")

      result.append({
          'title': title,
          'course_code': course_code,
          'date': date,
          'message': message_data,
          'sender': sender,
          'department' : department,
          'read' : False
      })

  return {'notifications': result, 'success': True}
  */
  static get_notifications() async {
    /*
    resp = requests.get(self.get_url_with_v(notifications_url),
                            auth=HttpNtlmAuth(self.username, self.password))

  if resp.status_code != 200:
      print("An Error Occurred. Check Credentials And Try Again.")
      return {'notifications': [], 'success': False}

  html = HTMLParser(resp.text)
  all_nots = html.css("#gv_notifications tr")[1:]
  result = [] 
  */

    NTLMClient client = Scrapper.client();

    var url = await Scrapper.get_url_with_v(notifications_url);
    var res = await client.get(Uri.parse(url));
    if (res.statusCode != 200) {
      return {'notifications': [], 'success': false};
    }
    var doc = parser.parse(res.body);
    var all_nots = doc.querySelectorAll("#gv_notifications tr").sublist(1);
    var result = [];

    /*
    for notification in all_nots:
      title = notification.css("td")[1].text()
      course_code = title.split(" - ")[-2].replace(" ", "")
      title = title[: title.find(" [")]

      date = notification.css("td")[2].text()

      entire_message = notification.css_first(
          "input").attributes['data-body']
      
      message_data = entire_message[:entire_message.find("------------------------------")].replace('<br />', '')
      department = entire_message.split("<br />------------------------------")[1].split("<br />")[2]
      sender = entire_message.split(
          "<br />------------------------------")[1].split("<br />")[1]
      sender = sender.replace(" \n", "")

      result.append({
          'title': title,
          'course_code': course_code,
          'date': date,
          'message': message_data,
          'sender': sender,
          'department' : department,
          'read' : False
      }) */

    for (var notification in all_nots) {
      var title = notification.querySelectorAll("td")[1].innerHtml;
      var course_codes = title.split(" - ");
      var course_code =
          course_codes[course_codes.length - 2].replaceAll(" ", "");
      title = title.substring(0, title.indexOf(" ["));

      var date = notification.querySelectorAll("td")[2].innerHtml;

      var entire_message = notification
          .querySelector("input")
          ?.attributes['data-body']
          ?.replaceAll("<br />", "");

      var message_data = entire_message
          ?.substring(
              0, entire_message.indexOf("------------------------------"))
          .replaceAll("<br />", "");
      var department = entire_message
          ?.split("------------------------------")[1]
          .split("\n")[2];
      var sender = entire_message
          ?.split("------------------------------")[1]
          .split("\n")[1];
      sender = sender?.replaceAll(" \n", "");

      result.add({
        'title': title,
        'course_code': course_code,
        'date': date,
        'message': message_data,
        'sender': sender,
        'department': department,
        'read': false
      });
    }
    return {'notifications': result, 'success': true};
  }

  static Future<void> getGrades(String courseCode) async {
    NTLMClient client = Scrapper.client();

    try {
      // Get the grades URL and extract the list of courses
      var response = await client.get(Uri.parse(grades_url));
      if (response.statusCode != 200) {
        print('Failed to access the page. Please try again.');
        return;
      }

      var html = response.body;

      var gradesDoc = parser.parse(html);
      print('Grades doc: $gradesDoc');

      // Select this form to then submit it

      final formElement = gradesDoc.querySelector('form[id="form2"]');
      print('Form element: $formElement');

      var options = extractCourses(html);

      // Select the course with the specified code
      var selectedCourse =
          options.firstWhere((option) => option['code'] == courseCode);

      // this is the html for the dropdown menu
      /*
          <p align="left">Course:
												<select name="ctl00$UnFormMainContent$smCrsLst" onchange="javascript:setTimeout(&#39;__doPostBack(\&#39;ctl00$UnFormMainContent$smCrsLst\&#39;,\&#39;\&#39;)&#39;, 0)" id="UnFormMainContent_smCrsLst" style="Z-INDEX: 0">
	<option selected="selected" value="">Choose a Course</option>
	<option value="258">MET Computer Science 6th Semester - CSEN601 Computer System Architecture</option>
	<option value="259">MET Computer Science 6th Semester - CSEN602 Operating Systems</option>
	<option value="260">MET Computer Science 6th Semester - MNGT601 Introduction to Management</option>
	<option value="523">MET Computer Science 6th Semester - DMET602 Network &amp; Media lab</option>
	<option value="561">MET Computer Science 6th Semester - CSEN604 Data Bases II</option>
	<option value="563">MET Computer Science 6th Semester - CSEN603 Software Engineering</option>

</select></p>
          */

      var gradesSelect = (gradesDoc.querySelector('#UnFormMainContent_smCrsLst')
          as SelectElement?);
      debugPrint('Grades form before: ${gradesSelect?.innerHtml}');

      gradesSelect?.attributes['value'] = selectedCourse['value'] ?? "258";

      debugPrint('Grades form after: ${gradesSelect?.innerHtml}');

      debugPrint('Grades doc after selecting course: $gradesDoc');

      // Submit the form to get the grades for the selected course
      var formData = {
        'ctl00\$UnFormMainContent\$smCrsLst': selectedCourse['value']
      };
      print('Form data: $formData');
      response = await client.post(Uri.parse(grades_url), body: formData);
      html = response.body;
      debugPrint('Grades for $courseCode: $html');
      extractGrades(html);
    } finally {
      // Close the client when done
      client.close();
    }
  }

  static List<Map<String, String>> extractCourses(String html) {
    var document = parser.parse(html);
    var options = document.querySelectorAll('option:not(:first-child)');

    return options
        .map((option) => {
              'code': parseCode(option.text),
              'value': option.attributes['value']
            })
        .toList() as List<Map<String, String>>;
  }

  static String? parseCode(String text) {
    var pattern = RegExp(r'(\w{4})\s*(\d{3})');
    var matches = pattern.allMatches(text);
    return matches.first.group(0);
  }

  static void extractGrades(String html) {
    // Parse the HTML and extract the grades for the selected course
    var document = parser.parse(html);
    var grades = document.querySelectorAll('.grades');
    // ...
  }

  String sortFunc(Map<String, String> dict) {
    if (dict['title']!.contains('Quiz')) {
      return '-';
    }

    return dict['title'] ?? "";
  }
}
