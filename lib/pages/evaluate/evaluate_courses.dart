import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gucentral/pages/evaluate/evaluate_a_course.dart';
import 'package:http/http.dart';
import 'package:ntlm/ntlm.dart';

import '../../widgets/MyColors.dart';
import '../../widgets/Requests.dart';

class EvaluateCourses extends StatefulWidget {
  const EvaluateCourses({super.key});

  @override
  State<EvaluateCourses> createState() => _EvaluateCoursesState();
}

class _EvaluateCoursesState extends State<EvaluateCourses> {
  bool loading = false;
  List coursesToEval = [];

  @override
  void initState() {
    initCoursesToEval();
    super.initState();
  }

  void initCoursesToEval() async {
    setState(() {
      loading = true;
    });
    var resp = await Requests.getCoursesToEval();
    if (resp['success']) {
      setState(() {
        coursesToEval = [
          {'name': 'Choose a course', 'value': '-1'}
        ];
        dropdownCourseValue = coursesToEval[0];
        coursesToEval += (resp['courses']);
      });
      debugPrint(coursesToEval.toString());
    } else {
      showSnackBar(context, resp['message']);
    }
    setState(() {
      loading = false;
    });
  }

  var dropdownCourseValue;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Courses To Evaluate",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        // width: ,
                        height: 55,
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 230, 230, 230),
                            borderRadius: BorderRadius.circular(13)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            // enableFeedback: true,
                            iconStyleData: const IconStyleData(
                              icon: Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(Icons.arrow_drop_down_outlined),
                              ),
                              iconSize: 30,
                            ),
                            isExpanded: true,
                            value: dropdownCourseValue,
                            style: const TextStyle(
                                // decoration: TextDecoration.underline,
                                color: Colors.black54,
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            // dropdownColor: MyColors.secondary,
                            dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            )),
                            underline: Container(
                              color: const Color(0),
                            ),
                            onChanged: (course) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownCourseValue = course;
                              });
                              if (dropdownCourseValue != coursesToEval.first) {
                                debugPrint("$dropdownCourseValue chosen");
                                courseChosen(course);
                                // widget.transcript.updateTranscript(value!);
                              }
                            },
                            items: coursesToEval
                                .map<DropdownMenuItem>((dynamic course) {
                              return DropdownMenuItem(
                                value: course,
                                child: buildCourseName(course['name']),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: isCourseLoaded ? 10 : 0),

                      /// if the user has chosen a course to evaluate
                      Expanded(
                        child: isCourseLoading
                            ? const Center(child: CircularProgressIndicator())
                            : isCourseLoaded
                                ? EvaluateACourse(course: dropdownCourseValue)
                                : const SizedBox(),
                      ),
                      //
                      // EvaluateACourse(course: dropdownCourseValue)
                    ],
                  ),
          ),
        );
      }),
    );
  }

  bool isCourseLoading = false;
  bool isCourseLoaded = false;
  void courseChosen(course) async {
    if (course['value'] == "-1") return;
    setState(() => isCourseLoading = true);
    // setState(() => loading = true);
    var resp = await Requests.checkEvaluated(course['value']);
    var alreadyEvaluated = !resp['success'];
    setState(() {
      isCourseLoading = false;
      isCourseLoaded = !alreadyEvaluated;
    });
    if (alreadyEvaluated) {
      showSnackBar(context, resp['message'],
          duration: const Duration(seconds: 7));
    }
    // else {
    //   // ignore: use_build_context_synchronously
    //   // Navigator.pushNamed(context, '/evaluate', arguments: course);
    // }
  }

  buildCourseName(String course) {
    if (course == coursesToEval[0]['name']) {
      return Text(course);
    }
    var courseSplit = course.split(' ');
    var name = courseSplit.sublist(0, courseSplit.length - 2).join(" ");
    var code = courseSplit.sublist(courseSplit.length - 2).join(" ");

    // add a seperator after the course name
    return Row(
      children: [
        Expanded(child: Text(code)),
        Expanded(flex: 2, child: Text(name)),
      ],
      // const Divider()
    );
    // Text.rich(TextSpan(text: "$name ", children: [
    //   TextSpan(text: code, style: TextStyle(color: MyColors.primaryVariant))
    // ]));
  }

  // void testLogin() async {
  //   print("test login");
  //   NTLMClient client = NTLMClient(
  //     domain: "",
  //     workstation: "LAPTOP",
  //     username: '${prefs.getString('username')}@student.guc.edu.eg',
  //     password: prefs.getString('password'),
  //   );
  //   print(client.username);
  //   print(client.password);
  //   String basicAuth =
  //       'Basic ' + base64.encode(utf8.encode('$username:$password'));
  //   print(basicAuth);

  //   Response r = await get(
  //       Uri.parse('https://cms.guc.edu.eg/apps/student/HomePageStn.aspx'),
  //       headers: <String, String>{'authorization': basicAuth});
  //   print(r.statusCode);
  //   print(r.body);

  //   var res = await client.get(Uri.parse('https://student.guc.edu.eg/'));
  // }
}
