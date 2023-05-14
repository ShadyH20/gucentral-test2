import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gucentral/utils/SharedPrefs.dart';
import 'package:gucentral/utils/constants.dart';
import 'package:gucentral/widgets/ExpandableChromeDino.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../widgets/MyColors.dart';
import '../../widgets/Requests.dart';
import '../main.dart';
import '../widgets/MenuWidget.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage>
    with TickerProviderStateMixin {
  bool loading = false;
  List courses = [];

// ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  @override
  void initState() {
    super.initState();
    courses = Requests.getCourses();
  }

  var dropdownCourseValue;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: attendanceAppBar(),
          backgroundColor: MyColors.background,
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      const SizedBox(height: 20),

                      buildAttLevel(),

                      const SizedBox(height: 15),

                      Container(
                        // width: ,
                        height: 55,
                        margin: EdgeInsets.zero,
                        // padding: const EdgeInsets.only(left: 10),
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
                            hint: const Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: Text('Choose A Course'),
                            ),
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
                            underline: Container(
                              color: Colors.transparent,
                            ),
                            onChanged: (course) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownCourseValue = course;
                              });
                              courseChosen(context, course);
                            },
                            items:
                                courses.map<DropdownMenuItem>((dynamic course) {
                              return DropdownMenuItem(
                                value: course,
                                child: buildCourseName(course),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

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
      }),
    );
  }

  List<dynamic> attendanceList = [];
  int attendanceLevel = 0;
  int absencesLeft = 0;
  int courseMaxAbsences = 0;

  bool isCourseLoading = false;
  bool isCourseLoaded = false;
  Future<void> courseChosen(context, course, [isPullRefresh = false]) async {
    if (!isPullRefresh) {
      await animController.reverse();
    }
    // await animateLevel(animController.reverseDuration);
    setState(() {
      startAnimation = false;
    });

    setState(() {
      isCourseLoading = true;
      attendanceList = Requests.getAttendanceSaved(course['code']);
      String attLevel =
          (Requests.getAttendanceLevelSaved(course['code']) as String)
              .replaceAll('"', '');
      absencesLeft = Requests.getAttendanceLeftSaved(course['code']);
      courseMaxAbsences =
          Requests.getAttendanceMaxAbsencesSaved(course['code']);
      attendanceLevel = int.parse(attLevel);
      if (!isPullRefresh) {
        animController.forward();
      }
    });
    var resp = await Requests.getAttendance(course['code']);
    var success = resp['success'];
    setState(() {
      isCourseLoading = false;
      isCourseLoaded = success;
    });
    if (!success) {
      showSnackBar(context, 'An error ocurred! Please try again.',
          duration: const Duration(seconds: 5));
      return;
    }
    List arr = resp['attendance'];
    var latestDate = DateTime.parse("1990-01-05 00:00:00");
    int attendanceCounter = 0;
    String maxAbs;
    await animController.reverse();
    try {
      maxAbs = prefs.getString('${course['code']}:maxAbsences')!;
      print('ALREADY WRITTEN MAX ABSENCES::: ${course['code']} -> $maxAbs');
    } catch (e) {
      print('MAX ABSENCES NOT WRITTEN YET');
      for (Map<String, dynamic> day in arr) {
        var date = DateFormat('y.MM.dd').parse(day['date']);
        // FRIDAY IS INITIAL VALUE
        if (latestDate.weekday == 5 || date.weekday > latestDate.weekday) {
          latestDate = date;
          attendanceCounter++;
        } else if (date.compareTo(latestDate) == 0) {
          attendanceCounter++;
        } else {
          break;
        }
      }
      prefs.setString(
          '${course['code']}:maxAbsences', (attendanceCounter * 3).toString());
      maxAbs = prefs.getString('${course['code']}:maxAbsences')!;
      print('ATT COUNTER::::::${course['code']} ${attendanceCounter * 3}');
    }

    int absenceCounter = 0;
    for (Map<String, dynamic> day in arr) {
      if (day['attendance'] == 'Absent') {
        absenceCounter++;
      }
    }

    setState(() {
      courseMaxAbsences = int.parse(maxAbs.replaceAll('"', ''));
      absencesLeft = courseMaxAbsences - absenceCounter;
      prefs.setString('${SharedPrefs.attendance}left:${course['code']}',
          absencesLeft.toString());
    });

    setState(() {
      if (attendanceList.length != arr.length) {
        startAnimation = true;
      }
      attendanceList = resp['attendance'];
      attendanceLevel = int.parse(resp['level']);
      animController.forward();
    });
    setState(() {
      startAnimation = true;
    });
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
      // systemOverlayStyle: SystemUiOverlayStyle(
      //     statusBarColor: MyColors.primary,
      //     statusBarIconBrightness: Brightness.dark,
      //     statusBarBrightness: Brightness.dark),
      elevation: 0,
      backgroundColor: MyColors.background,
      centerTitle: true,
      leadingWidth: 60.0,
      leading: const MenuWidget(),
      title: const Text(
        "Attendance",
        // textScaleFactor: 0.95,
        // style: TextStyle(color: MyColors.primary),
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

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late RefreshController refreshController;
  buildAttendance() {
    refreshController = RefreshController(initialRefresh: false);
    return AnimationLimiter(
      key: ValueKey("$attendanceList"),
      child: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        onRefresh: () async {
          await courseChosen(context, dropdownCourseValue, true);
          refreshController.refreshCompleted();
        },
        header: WaterDropHeader(
          waterDropColor: MyColors.primary,
          complete: Icon(
            Icons.check,
            color: MyColors.primary,
          ),
        ),
        child: ListView.builder(
          itemCount: attendanceList.length,
          itemBuilder: (context, index) {
            var attendance = attendanceList[attendanceList.length - 1 - index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 200),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: buildAttendanceItem(attendance, index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

// this is an attendance item: {"attendance": "Attended","date": "2023.02.22","type": "Practical","slot": "3rd"}
  buildAttendanceItem2(attendance) {
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
                      style: TextStyle(
                          color: MyColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      attendanceSlot + ' slot',
                      style: TextStyle(
                          color: MyColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  attendanceType,
                  style: TextStyle(
                      color: MyColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 25),
          SizedBox(
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

  bool startAnimation = false;
  buildAttendanceItem(attendance, int index) {
    var attendanceType = attendance['type'];
    var attendanceDate = attendance['date'];
    var attendanceSlot = attendance['slot'];
    var attendanceId = attendance['id'];
    var attendanceStatus = attendance['attendance'];
    var attendanceStatusColor = attendanceStatus == 'Attended'
        ? [const Color(0xffa3fa9d), const Color(0xff355a32)]
        : attendanceStatus == 'Absent'
            ? [const Color(0xfffa9d9d), const Color(0xff5a3232)]
            : [MyColors.secondary, MyColors.secondary];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
          color: attendanceStatusColor[0],
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ATTENDANCE ID //
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              attendanceId.toString(),
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black.withOpacity(0.3),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '$attendanceType | $attendanceSlot slot',
                  style: TextStyle(
                      color: attendanceStatusColor[1],
                      fontSize: 12,
                      fontWeight: FontWeight.w200),
                ),
                const SizedBox(height: 2),
                Text(
                  parseDate(attendanceDate),
                  style: TextStyle(
                      color: attendanceStatusColor[1],
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  attendanceStatus,
                  style: TextStyle(
                      color: attendanceStatusColor[1],
                      fontSize: 12,
                      fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String parseDate(attendanceDate) {
    var date = DateFormat('yyyy.MM.dd').parse(attendanceDate);
    var res = DateFormat('EEEE, MMMM d, yyyy').format(date);
    return res;
  }

  Color getLevelColor(int level) {
    if (level == 0) {
      return const Color(0xFF38c37d);
    } else if (level == 1) {
      return const Color(0xFF75d4d0);
    } else if (level == 2) {
      return const Color(0xFFffcb00);
    } else {
      return const Color(0xFFff5a64);
    }
  }

  Color getAttColor(int remaining, int total) {
    // total here is 3 or 6 or ...
    // remaining starts with total as initial value
    double percentage = remaining.toDouble() / total * 100;
    if (percentage > 75) {
      return const Color(0xFF38c37d);
    } else if (percentage > 50) {
      return const Color(0xFF75d4d0);
    } else if (percentage > 25) {
      return const Color(0xFFffcb00);
    } else if (percentage > 0) {
      return const Color(0xFFffaf00);
    } else {
      return const Color(0xFFff5a64);
    }
  }

  late AnimationController animController = AnimationController(
      vsync: this, duration: 200.ms, reverseDuration: 200.ms);

  buildAttLevel() {
    return AnimatedBuilder(
      animation: animController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: animController, curve: Curves.easeIn)),
              child: Opacity(
                opacity: Tween<double>(begin: 0.0, end: 1.0)
                    .evaluate(animController),
                child: Row(
                  children: [
                    Text(
                      'Level:',
                      style: kMainTitleStyle.copyWith(
                          color: MyColors.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      attendanceLevel.toString() == '0'
                          ? '-'
                          : attendanceLevel.toString(),
                      style: kMainTitleStyle.copyWith(
                          color: getLevelColor(attendanceLevel), fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: animController, curve: Curves.easeIn)),
              child: Opacity(
                opacity: Tween<double>(begin: 0.0, end: 1.0)
                    .evaluate(animController),
                child: Row(
                  children: [
                    Text(
                      'Absences Left:',
                      style: kMainTitleStyle.copyWith(
                          color: MyColors.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      courseMaxAbsences > 0
                          ? '${absencesLeft.toString()}/$courseMaxAbsences'
                          : '-',
                      style: kMainTitleStyle.copyWith(
                          color: getAttColor(absencesLeft, courseMaxAbsences),
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> animateLevel(Duration? reverseDuration) {
    return Future<void>.delayed(reverseDuration!)
        .then((value) => animController.forward());
  }
}
