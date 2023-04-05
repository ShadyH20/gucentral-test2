import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gucentral/pages/evaluate/evaluate_a_course.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ntlm/ntlm.dart';

import '../../widgets/MyColors.dart';
import '../../widgets/Requests.dart';
import '../widgets/MenuWidget.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool loading = false;
  List courses = [];

  @override
  void initState() {
    super.initState();
    courses = Requests.getCourses();
  }

  var dropdownCourseValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: attendanceAppBar(),
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
                  // const Text(
                  //   "Courses To Evaluate",
                  //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  // ),
                  // const SizedBox(height: 15),
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
                        hint: Text('Choose A Course'),
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
                          debugPrint("$dropdownCourseValue chosen");
                          courseChosen(course);
                        },
                        items: courses.map<DropdownMenuItem>((dynamic course) {
                          return DropdownMenuItem(
                            value: course,
                            child: buildCourseName(course),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: isCourseLoaded ? 10 : 0),

                  /// if the user has chosen a course to evaluate
                  Expanded(
                    child: buildAttendance(),
                  ),
                  //
                  // EvaluateACourse(course: dropdownCourseValue)
                ],
              ),
      ),
    );
  }

  List<dynamic> attendanceList = [];

  bool isCourseLoading = false;
  bool isCourseLoaded = false;
  void courseChosen(course) async {
    print(course);
    setState(() {
      isCourseLoading = true;
      attendanceList = Requests.getAttendanceSaved(course['code']);
    });
    var resp = await Requests.getAttendance(course['code']);
    var success = resp['success'];
    setState(() {
      isCourseLoading = false;
      isCourseLoaded = success;
      attendanceList = resp['attendance'];
    });
    if (!success) {
      showSnackBar(context, 'An error ocurred! Please try again.',
          duration: const Duration(seconds: 7));
    }
    print(attendanceList);
    // else {
    //   // ignore: use_build_context_synchronously
    //   // Navigator.pushNamed(context, '/evaluate', arguments: course);
    // }
  }

  buildCourseName(dynamic course) {
    var name = course['name'];
    var code = course['code'];

    // add a seperator after the course name
    return Row(
      children: [
        Expanded(child: Text(code)),
        Expanded(flex: 2, child: Text(name)),
      ],
    );
  }

  attendanceAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: MyColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark),
      elevation: 0,
      backgroundColor: MyColors.background,
      centerTitle: true,
      leadingWidth: 60.0,
      leading: const MenuWidget(),
      title: const Text(
        "Attendance",
        // textScaleFactor: 0.95,
        style: TextStyle(color: MyColors.primary),
      ),
      actions: [
        isCourseLoading
            ? const Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(),
        // IconButton(
        //   splashRadius: 15,
        //   // padding: EdgeInsets.symmetric(horizontal: 20.0),
        //   icon: SvgPicture.asset(
        //     "assets/images/refresh.svg",
        //     height: 24,
        //     color: MyColors.secondary,
        //   ),
        //   onPressed: () {
        //     // initCoursesToEval();
        //   },
        // ),
        Container(
          width: 20,
        )
      ],
    );
  }

  buildAttendance() {
    return ListView.builder(
      itemCount: attendanceList.length,
      itemBuilder: (context, index) {
        var attendance = attendanceList[index];
        return buildAttendanceItem(attendance);
      },
    );
  }

// this is an attendance item: {"attendance": "Attended","date": "2023.02.22","type": "Practical","slot": "3rd"}
  buildAttendanceItem(attendance) {
    var attendanceType = attendance['type'];
    var attendanceDate = attendance['date'];
    var attendanceSlot = attendance['slot'];
    var attendanceStatus = attendance['attendance'];
    var attendanceStatusColor = attendanceStatus == 'Attended'
        ? Colors.green
        : attendanceStatus == 'Absent'
            ? Colors.red[800]
            : MyColors.secondary;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: MyColors.background,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      parseDate(attendanceDate),
                      style: const TextStyle(
                          color: MyColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      attendanceSlot + ' slot',
                      style: const TextStyle(
                          color: MyColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  attendanceType,
                  style: const TextStyle(
                      color: MyColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 25),
          Container(
            width: 95,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: attendanceStatusColor?.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(13)),
                  child: Text(
                    attendanceStatus,
                    style: TextStyle(
                        color: attendanceStatusColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String parseDate(attendanceDate) {
    var date = DateFormat('yyyy.MM.dd').parse(attendanceDate);
    // var day = date.day;
    // var month = date.month;
    // var year = date.year;
    var res = DateFormat('EEE, d MMMM').format(date);
    return res;
  }
}
