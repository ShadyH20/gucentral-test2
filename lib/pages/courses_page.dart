import "dart:ffi";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/utils/SharedPrefs.dart";
import "package:gucentral/utils/build_sheet.dart";
import "package:gucentral/widgets/MenuWidget.dart";
// import "package:gucentral/widgets/MyColors.dart";
import "../utils/weight.dart";
import "../utils/weight_data.dart";
import "../widgets/Requests.dart";
import '../widgets/weight_card.dart';
import '../widgets/grade_card.dart';
import '../widgets/assignment_card.dart';
import '../utils/constants.dart';
import '../widgets/add_weight_card.dart';
import "package:wtf_sliding_sheet/wtf_sliding_sheet.dart";
import "package:dropdown_button2/dropdown_button2.dart";
import '../main.dart';
import 'package:provider/provider.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<dynamic> courses = [];

  List<dynamic> allGrades = [];
  double midterm = -1;
  BuildSheet? weightSheet;
  BuildSheet? changeNameSheet;
  int addWeightCardNum = 1;

  @override
  void initState() {
    super.initState();
    courses = Requests.getCourses();
  }

  dynamic dropdownValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  buildDropdown() {
    return Container(
      height: 55,
      padding: const EdgeInsets.only(left: 0),
      decoration: BoxDecoration(
          color: MyApp.isDarkMode.value
              ? MyColors.surface
              : const Color.fromARGB(255, 230, 230, 230),
          borderRadius: BorderRadius.circular(10)),
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
          value: dropdownValue,
          hint: const Padding(
            padding: EdgeInsets.only(left: 0.0),
            child: Text('Choose A Course'),
          ),
          style: TextStyle(
              // decoration: TextDecoration.underline,
              color: MyApp.isDarkMode.value ? Colors.white70 : Colors.black54,
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
              print(course);
              dropdownValue = course;
            });
            courseChosen(context, course);
          },
          items: courses.map<DropdownMenuItem>((dynamic course) {
            return DropdownMenuItem(
              value: course,
              child: buildCourseName(course),
            );
          }).toList(),
        ),
      ),
    );
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

  bool isCourseLoading = false;
  bool isCourseLoaded = false;

  Future<void> courseChosen(context, course) async {
    Provider.of<WeightData>(context, listen: false)
        .changeAllWeights(course['code']);

    // setState(() {
    //   isCourseLoading = true;
    //   allGrades = Requests.getGradesSaved(course['code']);
    // });

    print('waaaaaaatinggggg');
    final response = await Requests.getGrades(course['code']);
    print('waaaaaaatinggggg2');
    setState(() {
      if (!response['success']) {
        showSnackBar(
          context,
          response['message'] ?? 'Something went wrong',
        );
        return;
      }

      print('DONE: DAFOQ: ${response['all_grades']}');
      setState(() {
        allGrades = response['all_grades'];
        print('COURSEEE GRAAAADES: $allGrades');
      });
    });

    // var resp = await Requests.getAttendance(course['code']);
    // var success = resp['success'];
    // setState(() {
    //   isCourseLoading = false;
    //   isCourseLoaded = success;
    // });
    // if (!success) {
    //   showSnackBar(context, 'An error ocurred! Please try again.',
    //       duration: const Duration(seconds: 5));
    //   return;
    // }
    // setState(() {
    //   List arr = resp['grades'];
    //   if (gradesList.length != arr.length) {
    //     // startAnimation = true;
    //   }
    //   gradesList = resp['grades'];
    // });
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

  Widget buildGradeCard(dynamic item) {
    if (item.length == 1) {
      return GradeCard(
        key: UniqueKey(),
        title: item[0]['title'],
        score: item[0]['score'] == 'None' ? -1 : double.parse(item[0]['score']),
        scoreTotal: double.parse(item[0]['scoreTotal'] ?? '-1'),
      );
    }
    return AssignmentCard(title: item[0]['title'], elements: item);
  }

  buildNameSheet(BuildContext context) {
    changeNameSheet = BuildSheet(
        context: context,
        initialSnap: 0.3,
        snappings: [0.3],
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Text(
                  'Change Course Name',
                  style: kMainTitleStyle.copyWith(
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          );
        });
    changeNameSheet?.buildNotificationSheet();
  }

  buildWeightSheet(BuildContext context) {
    weightSheet = BuildSheet(
        context: context,
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Edit Weights',
                          style: kMainTitleStyle.copyWith(
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const WeightCardSection(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                WeightList(
                  weightList: Provider.of<WeightData>(context).allWeights,
                  addRemove: true,
                  addReorder: true,
                  makeReorderable: true,
                ),
                // const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      // flex: 6,
                      child: Container(
                        color: const Color.fromARGB(30, 0, 0, 0),
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 90),
              ],
            ),
          );
        });
    weightSheet?.buildNotificationSheet();
  }

  void setWeightCardNum({required bool increment}) {
    if (increment) {
      setState(() {
        addWeightCardNum++;
      });
    } else {
      setState(() {
        if (addWeightCardNum > 0) addWeightCardNum--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("Building courses page");
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.background,
        centerTitle: true,
        leadingWidth: 50.0,
        leading: const MenuWidget(),
        title: const Text(
          "Courses",
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
                    {'title': 'Quiz 1', 'score': 'None', 'scoreTotal': '10.0'}
                  ],
                  [
                    {'title': 'Quiz 2', 'score': '8', 'scoreTotal': '10.0'}
                  ],
                  [
                    {
                      'title': 'Assignment 1',
                      'elementName': 'Question 1',
                      'score': '6.3',
                      'scoreTotal': '10.0'
                    },
                    {
                      'title': 'Assignment 1',
                      'elementName': 'Question 2',
                      'score': '9',
                      'scoreTotal': '10.0'
                    },
                    {
                      'title': 'Assignment 1',
                      'elementName': 'Question 3',
                      'score': '2',
                      'scoreTotal': '10.0'
                    }
                  ],
                  [
                    {'title': 'Quiz 3', 'score': '5', 'scoreTotal': '10.0'}
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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
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
                  buildDropdown(),
                ],
              ),
              const SizedBox(height: 30),
              dropdownValue != null
                  ? Expanded(
                      child: ListView(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: dropdownValue['name'],
                                  style: kMainTitleStyle.copyWith(
                                      fontSize: 26, color: MyColors.primary),
                                ),
                                const WidgetSpan(child: SizedBox(width: 10)),
                                WidgetSpan(
                                  child: SizedBox(
                                    // margin: const EdgeInsets.only(bottom: 1),
                                    height: 18,
                                    width: 18,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0),
                                      // iconSize: 5,
                                      splashRadius: 17,
                                      iconSize: 15,
                                      alignment: Alignment.center,
                                      icon: SvgPicture.asset(
                                        "assets/images/edit.svg",
                                      ),
                                      onPressed: () {
                                        buildNameSheet(context);
                                      },
                                    ),
                                  ),
                                  baseline: TextBaseline.alphabetic,
                                  // alignment: PlaceholderAlignment.middle,
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
                                    TextSpan(
                                      text: 'Weights',
                                      style: kMainTitleStyle.copyWith(
                                        color: MyColors.primary,
                                      ),
                                    ),
                                    const WidgetSpan(
                                        child: SizedBox(width: 10)),
                                    WidgetSpan(
                                      child: SizedBox(
                                        // margin: const EdgeInsets.only(bottom: 5),
                                        height: 18,
                                        width: 18,
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          // iconSize: 5,
                                          splashRadius: 17,
                                          iconSize: 15,
                                          alignment: Alignment.center,
                                          icon: SvgPicture.asset(
                                            "assets/images/edit.svg",
                                            // fit: BoxFit.scaleDown,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              buildWeightSheet(context);
                                            });
                                          },
                                        ),
                                      ),
                                      baseline: TextBaseline.alphabetic,
                                      // alignment: PlaceholderAlignment.middle,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 0.7,
                                color: MyColors.secondary.withOpacity(0.5),
                              ),
                              Provider.of<WeightData>(context)
                                      .allWeights
                                      .isNotEmpty
                                  ? WeightList(
                                      weightList:
                                          Provider.of<WeightData>(context)
                                              .allWeights)
                                  : const Text(
                                      'You haven\'t added this course\'s weights yet!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 45),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Grades',
                                      style: kMainTitleStyle.copyWith(
                                        color: MyColors.primary,
                                      ),
                                    ),
                                    midterm >= 0
                                        ? Row(
                                            children: [
                                              Text(
                                                'Midterm  |  ',
                                                style: kMainTitleStyle.copyWith(
                                                  color: MyColors.primary,
                                                ),
                                              ),
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
                                Divider(
                                  thickness: 0.7,
                                  color: MyColors.secondary.withOpacity(0.5),
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
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorMessage extends StatefulWidget {
  const ErrorMessage({
    super.key,
    required this.errorVisible,
  });

  final bool errorVisible;

  @override
  State<ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.errorVisible,
      child: Text(
        '*Please fill in all fields*',
        style: kSubTitleStyle.copyWith(
          fontWeight: FontWeight.w400,
          color: Colors.red,
        ),
      ),
    );
  }
}

class WeightList extends StatelessWidget {
  const WeightList({
    super.key,
    required this.weightList,
    this.addRemove = false,
    this.addReorder = false,
    this.makeReorderable = false,
  });
  final List<Weight> weightList;
  final bool addRemove;
  final bool addReorder;
  final bool makeReorderable;

  List<String> getBest(Map item) {
    if (item['best'] == null || item['best'].length != 2) return ['', ''];
    return [item['best'][0].toString(), item['best'][1].toString()];
  }

  // ReorderableListView buildWeightCardList() {
  //   return ReorderableListView(children: children, onReorder: onReorder)
  // }

  WeightCard buildWeightCard(Weight inputWeight) {
    return WeightCard(
      weightData: inputWeight,
      addRemove: addRemove,
      addReorder: addReorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return !makeReorderable
        ? Column(
            children: weightList.map((item) {
              return buildWeightCard(item);
            }).toList(),
          )
        : SizedBox(
            // width: 100,
            height: 295,
            // color: Color(0x44FF0000),
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) async {
                Provider.of<WeightData>(context, listen: false)
                    .setIsDismissable(false);

                Provider.of<WeightData>(context, listen: false)
                    .updateWeightPosition(oldIndex, newIndex);

                Provider.of<WeightData>(context, listen: false)
                    .setIsDismissable(true);
              },
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.all(0),
              children: weightList.map((item) {
                return Container(
                  key: ValueKey(item),
                  decoration: const BoxDecoration(
                    // color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: buildWeightCard(item),
                );
              }).toList(),
            ),
          );
  }
}

class WeightCardSection extends StatefulWidget {
  const WeightCardSection({super.key});

  @override
  State<WeightCardSection> createState() => _WeightCardSectionState();
}

class _WeightCardSectionState extends State<WeightCardSection> {
  bool showMainWeightCard = false;
  bool errorVisible = false;

  void setVisibility(bool value) {
    setState(() {
      showMainWeightCard = value;
    });
  }

  void setErrorVisibility(bool value) {
    setState(() {
      errorVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: showMainWeightCard ? 184 : 32,
      padding: const EdgeInsets.all(0),
      // margin: const EdgeInsets.only(bottom: 10),
      child: !showMainWeightCard
          ? Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 32,
                width: 130,
                padding: const EdgeInsets.all(0),
                child: TextButton(
                  onPressed: () {
                    print('geeeeb elcaaaard');
                    setVisibility(true);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        "Add Weight",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 160,
                  child: AddWeightCard(
                    showFunction: setVisibility,
                    showError: setErrorVisibility,
                  ),
                ),
                const SizedBox(height: 5),
                ErrorMessage(errorVisible: errorVisible)
              ],
            ),
    );
  }
}
