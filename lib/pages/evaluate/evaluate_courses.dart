import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gucentral/pages/evaluate/evaluate_a_course.dart';
import 'package:http/http.dart';
import 'package:ntlm/ntlm.dart';

import '../../main.dart';
import '../../widgets/MyColors.dart';
import '../../widgets/Requests.dart';

class EvaluateCourses extends StatefulWidget {
  const EvaluateCourses({super.key});

  @override
  State<EvaluateCourses> createState() => _EvaluateCoursesState();
}

class _EvaluateCoursesState extends State<EvaluateCourses>
    with AutomaticKeepAliveClientMixin<EvaluateCourses> {
  // ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  bool loading = false;
  List coursesToEval = [];

  @override
  void initState() {
    super.initState();
    initCoursesToEval();
  }

  void initCoursesToEval() async {
    setState(() {
      loading = true;
    });
    var resp = await Requests.getCoursesToEval();
    if (resp['success']) {
      setState(() {
        coursesToEval = [];
        // dropdownCourseValue = coursesToEval[0];
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
          backgroundColor: MyColors.background,
          body: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Courses To Evaluate",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 55,
                        // padding: const EdgeInsets.only(left: 0),
                        decoration: BoxDecoration(
                            color: MyApp.isDarkMode.value
                                ? MyColors.surface
                                : const Color.fromARGB(255, 230, 230, 230),
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
                            style: TextStyle(
                                // decoration: TextDecoration.underline,
                                color: MyApp.isDarkMode.value
                                    ? Colors.white70
                                    : Colors.black54,
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            // dropdownColor: MyColors.secondary,
                            dropdownStyleData: const DropdownStyleData(
                                offset: Offset(0, 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                )),
                            hint: const Text("Choose a Course"),
                            underline: Container(
                              color: const Color(0),
                            ),
                            onChanged: (course) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownCourseValue = course;
                              });
                              debugPrint("$dropdownCourseValue chosen");
                              courseChosen(context, course);
                              // widget.transcript.updateTranscript(value!);
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
  void courseChosen(context, course) async {
    if (course['value'] == "-1") return;
    setState(() => isCourseLoading = true);
    // setState(() => loading = true);
    var resp = await Requests.checkCourseEvaluated(course['value']);
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
    var courseSplit = course.split(' ');
    var name = courseSplit.sublist(0, courseSplit.length - 2).join(" ");
    var code = courseSplit.sublist(courseSplit.length - 2).join(" ");

    // add a seperator after the course name
    return Row(
      children: [
        Expanded(flex: 4, child: Text(code)),
        Expanded(
            flex: 9,
            child: AutoSizeText(
              name,
              maxLines: 2,
              // maxFontSize: 18,
            )),
      ],
      // const Divider()
    );
    // Text.rich(TextSpan(text: "$name ", children: [
    //   TextSpan(text: code, style: TextStyle(color: MyColors.primaryVariant))
    // ]));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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
