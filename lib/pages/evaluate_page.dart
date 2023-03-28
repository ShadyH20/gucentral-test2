import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gucentral/widgets/Requests.dart';

import '../widgets/MenuWidget.dart';
import '../widgets/MyColors.dart';

const labels = [
  'The timetable works efficiently as far as my activities are concerned',
  'Any changes in the course or teaching have been communicated effectively ',
  'The course  is well organized and is running smoothly ',
  'The required amount of work for this course is adequate',
  'I have received sufficient advice and support with my studies ',
  'I have been able to contact staff when I needed to ',
  'Good advice was available when I needed to make study choices',
  'The library resources and services are good enough for my needs',
  'I have been able to access general IT resources when I needed to',
  'I have been able to access specialized equipment, facilities or room when I needed to ',
  'The course has helped me present myself with confidence',
  'My communication skills have improved',
  'As a result of the course, I feel confident in tackling unfamiliar problems',
  'The criteria used in marking have been clear in advance',
  'Assessment arrangements and marking have been fair',
  'Feedback on my work has been prompt',
  'I have received detailed comments on my work',
  'Feedback on my work has helped me clarify things I did not understand.',
  'Overall, I am satisfied with the quality of the course.'
];

class EvaluatePage extends StatefulWidget {
  const EvaluatePage({super.key});

  @override
  State<EvaluatePage> createState() => _EvaluatePageState();
}

class _EvaluatePageState extends State<EvaluatePage> {
  bool loading = false;
  int pageIndex = 0;
  List coursesToEval = [];

  var dropdownCourseValue;

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
        dropdownCourseValue = "-1";
        coursesToEval = [
          {'name': 'Choose a course', 'value': '-1'}
        ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: evaluateAppBar(),
      bottomNavigationBar: buildBottomNavBar(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Courses To Evaluate",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    // width: ,
                    height: 70,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 230, 230, 230),
                        borderRadius: BorderRadius.circular(13)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        enableFeedback: true,
                        iconStyleData: const IconStyleData(
                            icon: Icon(Icons.arrow_drop_down_outlined),
                            iconSize: 30),
                        isExpanded: true,
                        value: dropdownCourseValue,
                        style: const TextStyle(
                            // decoration: TextDecoration.underline,
                            color: Colors.black54,
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        // dropdownColor: MyColors.secondary,
                        dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        )),
                        underline: Container(
                          color: const Color(0),
                        ),
                        onChanged: (dynamic courseVal) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownCourseValue = courseVal!;
                          });
                          if (dropdownCourseValue != coursesToEval.first) {
                            debugPrint("$dropdownCourseValue chosen");
                            courseChosen(courseVal);
                            // widget.transcript.updateTranscript(value!);
                          }
                        },
                        items: coursesToEval
                            .map<DropdownMenuItem>((dynamic course) {
                          return DropdownMenuItem(
                            value: course['value'],
                            child: buildCourseName(course['name']),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  BottomNavigationBar buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: pageIndex,
      onTap: (value) {
        setState(() {
          pageIndex = value;
        });
      },
      iconSize: 30,
      selectedIconTheme: const IconThemeData(size: 40),
      unselectedFontSize: 16,
      selectedFontSize: 20,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_outlined),
            label: "Evaluate Courses"),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded), label: "Evaluate Academics"),
      ],
    );
  }

  evaluateAppBar() {
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
        "Evaluate",
        // textScaleFactor: 0.95,
        style: TextStyle(color: MyColors.primary),
      ),
      actions: [
        IconButton(
          splashRadius: 15,
          // padding: EdgeInsets.symmetric(horizontal: 20.0),
          icon: SvgPicture.asset(
            "assets/images/refresh.svg",
            height: 24,
            color: MyColors.secondary,
          ),
          onPressed: () {
            initCoursesToEval();
          },
        ),
        Container(
          width: 10,
        )
      ],
    );
  }

  void courseChosen(course) async {
    setState(() => loading = true);
    var resp = await Requests.checkEvaluated(course);
    var alreadyEvaluated = !resp['success'];
    setState(() => loading = false);
    showSnackBar(context, resp['message'], duration: Duration(seconds: 7));
  }

  buildCourseName(String course) {
    var courseSplit = course.split(' ');
    var name = courseSplit.sublist(0, courseSplit.length - 2).join(" ");
    var code = courseSplit.sublist(courseSplit.length - 3).join(" ");
    return Text(course);
  }
}
