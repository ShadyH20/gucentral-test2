import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gucentral/pages/schedule_page.dart';
import 'package:gucentral/widgets/MyColors.dart';
import 'package:gucentral/widgets/Requests.dart';
import 'package:jumping_dot/jumping_dot.dart';

import '../../main.dart';
import '../../utils/SharedPrefs.dart';

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

const values = [
  'Strongly Agree',
  'Agree',
  'Slightly Agree',
  'Slightly Disagree',
  'Disagree',
  'Strongly Disagree',
];

const labels2RL = [
  ['Always', 'Almost never'],
  ['1 hour', '6 hours'],
  ['Very Great', 'Very Low'],
];

const labels2 = [
  'I attended the Lecture/Course',
  'My weekly time expenditure for preparation/wrap-up of the Lecture/Course was',
  'How great is the amount of work for this course to you'
];

class EvaluateACourse extends StatefulWidget {
  final dynamic course;

  const EvaluateACourse({super.key, required this.course});

  @override
  State<EvaluateACourse> createState() => _EvaluateACourseState();
}

class _EvaluateACourseState extends State<EvaluateACourse> {
  // ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  final _formKey = GlobalKey<FormState>();
  final _fieldKeys =
      List.generate(labels.length + labels2.length, (index) => GlobalKey());

  List<int> radio1Vals = List.filled(labels.length, 0);
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: MyColors.background,
          // appBar: AppBar(
          //   systemOverlayStyle: const SystemUiOverlayStyle(
          //       statusBarColor: MyColors.background,
          //       statusBarIconBrightness: Brightness.dark,
          //       statusBarBrightness: Brightness.dark),
          //   backgroundColor: MyColors.background,
          //   foregroundColor: MyColors.secondary,
          //   title: const Text(
          //     "Evaluate a Course",
          //     style: TextStyle(fontWeight: FontWeight.w500),
          //   ),
          // ),
          body: isDone
              ? null
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // const SizedBox(height: 30),
                        // const Text(
                        //   'Evaluating',
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // Container(
                        //   alignment: Alignment.center,
                        //   child: buildCourseName(widget.course['name']),
                        // ),
                        const SizedBox(
                          height: 25,
                        ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Container(
                        //     margin: const EdgeInsets.only(right: 20),
                        //     child: const Text(
                        //       'Choose a rating to autofill for all fields!',
                        //       style: TextStyle(
                        //         fontSize: 20,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        buildAutoFill(),

                        const SizedBox(
                          height: 25,
                        ),

                        /// THE FIRST 19 RATINGS ///
                        buildRadios1(),

                        // DIVIDER //
                        buildDoubleLine(),

                        /// LAST 3 RATINGS ///
                        buildRadios2(),

                        // DIVIDER //
                        buildDoubleLine(),

                        /// REMARK TEXTAREA ////
                        buildRemark(),

                        /// POST EVALUATION BUTTON ///
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ElevatedButton(
                                onPressed: () {
                                  postEvaluation();
                                },
                                style: ElevatedButton.styleFrom(
                                  enableFeedback: true,
                                  padding: submitting
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 15)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  // fixedSize:
                                  //     Size(MediaQuery.of(context).size.width * 0.5, 50),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: submitting
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(width: 15),
                                            Text("Posting "),
                                          ],
                                        ),
                                      )
                                    : const Text("Post Evaluation"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }

  List<Widget> _buildRadioButtons1(int index) {
    List<Widget> radioButtonsList = [];

    for (int i = 0; i < values.length; i++) {
      radioButtonsList.add(
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              radio1Vals[index] = i + 1;
            }),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<int>(
                  // activeColor: (sentimentIcons[i] as Icon).color,
                  value: i + 1,
                  groupValue: radio1Vals[index],
                  onChanged: (int? value) {
                    setState(() {
                      radio1Vals[index] = value!;
                    });
                  },
                ),
                sentimentIcons[i],
                Text(
                  values[i],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return radioButtonsList;
  }

  List radio2Vals = List.filled(labels2.length, 0);
  Row _buildRadioButtons2(int index) {
    List<Widget> radioButtonsList = [];

    for (int i = 0; i < 6; i++) {
      radioButtonsList.add(
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              radio2Vals[index] = i + 1;
            }),
            child: FormField(
              builder: (field) => Column(
                children: [
                  Radio<int>(
                    value: i + 1,
                    groupValue: radio2Vals[index],
                    onChanged: (int? value) {
                      setState(() {
                        radio2Vals[index] = value!;
                      });
                    },
                  ),
                  Text(
                    (i + 1).toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Row(children: radioButtonsList);
  }

  final List<Widget> sentimentIcons = [
    const Icon(
      Icons.sentiment_very_satisfied_rounded,
      color: Colors.green,
    ),
    const Icon(
      Icons.sentiment_satisfied_rounded,
      color: Color.fromARGB(255, 101, 175, 76),
    ),
    const Icon(Icons.sentiment_neutral_rounded,
        color: Color.fromARGB(255, 145, 172, 38)),
    const Icon(
      Icons.sentiment_neutral_rounded,
      color: Color.fromARGB(255, 201, 186, 46),
    ),
    Icon(
      Icons.sentiment_dissatisfied_rounded,
      color: Colors.orange[800],
    ),
    const Icon(
      Icons.sentiment_very_dissatisfied_rounded,
      color: Colors.red,
    ),
  ];

  final _focusRadio = FocusNode();

  Widget buildRadios1() {
    return Column(
        children: List.generate(
      labels.length,
      (index) => FormBuilderField(
        key: _fieldKeys[index],
        name: "Radio",
        focusNode: index == 0 ? _focusRadio : null,
        validator: (value) {
          return radio1Vals[index] == 0 ? "Required" : null;
        },
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: field.hasError ? 5 : 20),
              child: Row(
                children: [
                  field.hasError && !field.isValid
                      ? const Text(
                          '* Req.',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  field.hasError ? const SizedBox(width: 5) : const SizedBox(),
                  Flexible(
                    child: Text(
                      '${index + 1}.  ${labels[index]}',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: MyColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildRadioButtons1(index),
              ),
            ),

            // SEPERATOR
            index != labels.length - 1
                ? const SizedBox(
                    height: 60,
                    child: Divider(thickness: 2),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    ));
  }

  buildRadios2() {
    return Column(
        children: List.generate(
      3,
      (index) => FormField(
        key: _fieldKeys[labels.length + index],
        validator: (value) {
          return radio2Vals[index] == 0 ? "Required" : null;
        },
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  field.hasError && !field.isValid
                      ? const Text(
                          '* Req.',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  field.hasError ? const SizedBox(width: 8) : const SizedBox(),
                  Flexible(
                    child: Text(
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      labels2[index],
                      style: TextStyle(
                        fontSize: 17.0,
                        // height: 0.9,
                        fontWeight: FontWeight.w400,
                        color: MyColors.secondary,

                        // letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Center(
                        child: Text(
                      labels2RL[index][0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17),
                    )),
                  ),
                  const Spacer(),
                  Expanded(flex: 10, child: _buildRadioButtons2(index)),
                  const Spacer(),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Text(labels2RL[index][1],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17)),
                    ),
                  ),
                ],
              ),
            ),
            index != 2
                ? const SizedBox(
                    height: 60,
                    child: Divider(thickness: 2),
                  )
                : Container(),
          ],
        ),
      ),
    ));
  }

  //controller for the remark input
  final _remarkController = TextEditingController();
  buildRemark() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Course critique (e.g. likes, dislikes) and suggestions for improvement',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: MyColors.secondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
              controller: _remarkController,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              maxLines: 6,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  hintText: "Type Here...",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: context.isDarkMode
                          ? BorderSide(
                              color: MyColors.secondary.withOpacity(0.7),
                            )
                          : BorderSide()),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: MyColors.primaryVariant, width: 2),
                      borderRadius: BorderRadius.circular(12)))),
        )
      ],
    );
  }

  buildDoubleLine() {
    return Column(
      children: [
        const SizedBox(height: 35),
        Divider(thickness: 3, color: MyColors.secondary.withOpacity(0.7)),
        Divider(
            thickness: 3,
            height: 5,
            color: MyColors.secondary.withOpacity(0.7)),
        const SizedBox(height: 35)
      ],
    );
  }

  bool submitting = false;

  buildCourseName(course) {
    var courseSplit = course.split(' ');
    var name = courseSplit.sublist(0, courseSplit.length - 2).join(" ");
    var code = courseSplit.sublist(courseSplit.length - 2).join(" ");

    // add a seperator after the course name
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            code,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MyColors.secondary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MyColors.secondary,
            ),
          ),
        ],
        // const Divider()
      ),
    );
  }

  var autoFillRating = 0;
  buildAutoFill() {
    // this will return a row containing a dropdown to select a rating from the 6 options
    // and an apply to all button
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          textAlign: TextAlign.center,
          message: 'Choose a rating to autofill all fields!\nUse wisely ;)',
          verticalOffset: 15,
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 3),
          child: Icon(
            Icons.info_outline,
            size: 25,
            color: MyColors.secondary.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          height: 35,
          width: 126,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.arrow_drop_down_rounded),
              ),
              isExpanded: true,
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.only(left: 15),
              ),
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: MyColors.secondary.withOpacity(0.7)),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              dropdownStyleData: const DropdownStyleData(
                  padding: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  )),
              value: autoFillRating,
              items: const [
                    DropdownMenuItem(
                        value: 0,
                        child: IntrinsicWidth(
                          child: Text("Choose Rating",
                              style: TextStyle(fontSize: 13)),
                        )),
                  ] +
                  List.generate(
                    6,
                    (index) => DropdownMenuItem(
                      // alignment: Alignment.centerLeft,
                      value: index + 1,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          sentimentIcons[index],
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              values[index],
                              maxLines: 2,
                              softWrap: true,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              onChanged: (value) {
                setState(() {
                  autoFillRating = value as int;
                });
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 35,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: MyColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            onPressed: () {
              if (autoFillRating != 0) {
                setState(() {
                  radio1Vals = List.filled(radio1Vals.length, autoFillRating);
                });
              }
            },
            child: const Text("Apply to All"),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  bool isDone = false;
  postEvaluation() async {
    // setState(() {
    //   submitting = true;
    // });
    // await Future.delayed(Duration(seconds: 3));

    // setState(() {
    //   submitting = false;
    // });

    bool isValid = _formKey.currentState!.validate();
    // _focusRadio.requestFocus();
    print("Form valid: $isValid");
    if (!isValid) {
      showSnackBar(context, "Please fill out all the required fields.");
    } else {
      var confirm = await buildConfirmationDialog(
          context,
          MyColors,
          MyColors.primary,
          Icons.warning_amber_rounded,
          "You are about to submit\nan evaluation to the GUC system.\n\nThis action is NOT reversible!",
          "Yes, Post Evaluation",
          "No, Cancel");

      if (!confirm) return;
      print(widget.course);
      print("Radio 1: $radio1Vals");
      print("Radio 2: $radio2Vals");
      print("Remark: ${_remarkController.text}");
      setState(() {
        submitting = true;
      });
      var res = await Requests.evaluateCourse(widget.course['value'],
          radio1Vals, radio2Vals, _remarkController.text);
      // Map<String, dynamic> res = {
      //   'success': true,
      //   'message': 'Evaluationnnnnnnnn submitted successfully!'
      // };
      // await Future.delayed(Duration(seconds: 4));

      setState(() {
        submitting = false;
      });
      showSnackBar(context, res['message']);
      if (res['success'] ?? false) {
        setState(() {
          isDone = true;
        });
      }
    }
  }
}
