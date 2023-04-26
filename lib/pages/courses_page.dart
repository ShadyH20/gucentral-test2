import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/utils/build_sheet.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "../widgets/Requests.dart";
import '../widgets/weight_card.dart';
import '../widgets/grade_card.dart';
import '../widgets/assignment_card.dart';
import '../utils/constants.dart';
import "package:wtf_sliding_sheet/wtf_sliding_sheet.dart";
import '../main.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<dynamic> courses = [];

  // _CoursesPageState() {
  // }
  @override
  void initState() {
    super.initState();
    getCourses();
  }

  getCourses() {
    courses = Requests.getCourses();
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

  List<dynamic> gradesList = [];
  bool isCourseLoading = false;
  bool isCourseLoaded = false;
  Future<void> courseChosen(context, course) async {
    setState(() {
      isCourseLoading = true;
      gradesList = Requests.getAttendanceSaved(course['code']);
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
    setState(() {
      List arr = resp['grades'];
      if (gradesList.length != arr.length) {
        // startAnimation = true;
      }
      gradesList = resp['grades'];
    });
  }

  // var dropdownCourseValue;
  Color getScoreColor(double score) {
    if (score > 80) {
      return const Color(0xFF38c37d);
    } else if (score > 60) {
      return const Color(0xFF75d4d0);
    } else if (score > 40) {
      return const Color(0xFFffcb00);
    } else if (score > 20) {
      return const Color(0xFFffaf00);
    } else {
      return const Color(0xFFff5a64);
    }
  }

  Widget buildGradeCard(List<Map> item) {
    if (item.length == 1) {
      return GradeCard(
        key: UniqueKey(),
        title: item[0]['title'],
        score: item[0]['score'].toDouble(),
        scoreTotal: item[0]['scoreTotal'].toDouble(),
      );
    }
    return AssignmentCard(title: item[0]['title'], elements: item);
  }

  buildWeightSheet(BuildContext context) {
    weightSheet ??= BuildSheet(
        context: context,
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit Weights',
                  style: kMainTitleStyle.copyWith(
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 30),
                const WeightCard(text: 'Quizzes', weight: '50'),
              ],
            ),
          );
        });
    weightSheet?.buildNotificationSheet();
  }

  List<Map> allWeights = [];
  List<List<Map>> allGrades = [];
  double midterm = -1;
  BuildSheet? weightSheet;

  @override
  Widget build(BuildContext context) {
    // print("Building courses page");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: MyColors.primary,
        //     statusBarIconBrightness: Brightness.dark,
        //     statusBarBrightness: Brightness.dark),
        elevation: 0,
        backgroundColor: MyColors.background,
        centerTitle: true,
        leadingWidth: 50.0,
        leading: const MenuWidget(),
        title: const Text(
          "Courses",
          style: TextStyle(color: MyColors.primary),
        ),
        actions: [
          IconButton(
            // padding: EdgeInsets.symmetric(horizontal: 20.0),
            icon: SvgPicture.asset(
              "assets/images/edit.svg",
              height: 30,
              // color: MyColors.secondary,
            ),
            onPressed: () {
              setState(() {
                midterm = 67.123796782314;
                allGrades = [
                  [
                    {'title': 'Quiz 1', 'score': 4.0, 'scoreTotal': 10.0}
                  ],
                  [
                    {'title': 'Quiz 2', 'score': 8, 'scoreTotal': 10.0}
                  ],
                  [
                    {
                      'title': 'Assignment 1',
                      'elementName': 'Question 1',
                      'score': 6.3,
                      'scoreTotal': 10.0
                    },
                    {
                      'title': 'Assignment 1',
                      'elementName': 'Question 2',
                      'score': 9,
                      'scoreTotal': 10.0
                    },
                    {
                      'title': 'Assignment 1',
                      'elementName': 'Question 3',
                      'score': 2,
                      'scoreTotal': 10.0
                    }
                  ],
                  [
                    {'title': 'Quiz 4', 'score': 9.4, 'scoreTotal': 10.0}
                  ],
                ];
              });
            },
          ),
          Container(
            width: 10,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 15,
        ),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'Show All Midterm Grades',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 20,
                  width: 100,
                  color: Colors.black,
                  // child: const Text('huh??'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Introduction to Communication Networks',
                          style: kMainTitleStyle.copyWith(fontSize: 26),
                        ),
                        const WidgetSpan(child: SizedBox(width: 10)),
                        WidgetSpan(
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.centerLeft,
                            icon: SvgPicture.asset(
                              "assets/images/edit.svg",
                              height: 18,
                            ),
                            onPressed: () {},
                          ),
                          baseline: TextBaseline.alphabetic,
                          alignment: PlaceholderAlignment.middle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Weights',
                              style: kMainTitleStyle,
                            ),
                            const WidgetSpan(child: SizedBox(width: 10)),
                            WidgetSpan(
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                // iconSize: 5,
                                alignment: Alignment.centerLeft,
                                icon: SvgPicture.asset(
                                  "assets/images/edit.svg",
                                  height: 18,
                                  // fit: BoxFit.scaleDown,
                                ),
                                onPressed: () {
                                  setState(() {
                                    buildWeightSheet(context);
                                    // allWeights = [
                                    //   {
                                    //     'text': 'Quizzes',
                                    //     'weight': '30',
                                    //     'best': ['4', '5']
                                    //   },
                                    //   {
                                    //     'text': 'In-Class Assignments',
                                    //     'weight': '20',
                                    //     'best': ['8', '10']
                                    //   },
                                    //   {
                                    //     'text': 'Midterms',
                                    //     'weight': '30',
                                    //   },
                                    // ];
                                  });
                                },
                              ),
                              baseline: TextBaseline.alphabetic,
                              alignment: PlaceholderAlignment.middle,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 0.7,
                      ),
                      Column(
                        children: allWeights.isNotEmpty
                            ? allWeights.map((item) {
                                return WeightCard(
                                  text: item['text'],
                                  weight: item['weight'],
                                  best: item['best'] ?? [],
                                );
                              }).toList()
                            : const [
                                Text(
                                  'You haven\'t added this course\'s weights yet!',
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                ),
                              ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 45),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Grades', style: kMainTitleStyle),
                            midterm >= 0
                                ? Row(
                                    children: [
                                      const Text('Midterm  |  ',
                                          style: kMainTitleStyle),
                                      Text(
                                        '${midterm.toStringAsFixed(1)}%',
                                        style: kMainTitleStyle.copyWith(
                                          color: getScoreColor(midterm),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(''),
                          ],
                        ),
                        const Divider(
                          thickness: 0.7,
                        ),
                        Column(
                          children: allGrades.map((item) {
                            return buildGradeCard(item);
                          }).toList(),
                        ),
                        // ListView.builder(itemCount: allGrades.length ,itemBuilder: (context, index) {
                        //   print("Building grade card $index");
                        //   return buildGradeCard(allGrades[index]);
                        // }),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
