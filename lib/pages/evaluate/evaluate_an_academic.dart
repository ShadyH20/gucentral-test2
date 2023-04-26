import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gucentral/pages/schedule_page.dart';
import 'package:gucentral/widgets/MyColors.dart';
import 'package:gucentral/widgets/Requests.dart';

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

class EvaluateAnAcademic extends StatefulWidget {
  final dynamic academic;

  const EvaluateAnAcademic({super.key, required this.academic});

  @override
  State<EvaluateAnAcademic> createState() => _EvaluateAnAcademicState();
}

class _EvaluateAnAcademicState extends State<EvaluateAnAcademic>
    with AutomaticKeepAliveClientMixin<EvaluateAnAcademic> {
  final _formKey = GlobalKey<FormState>();

  List<int> radio1Vals = List.filled(labels.length, 0);
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: MyColors.background,
          appBar: AppBar(
            // systemOverlayStyle: const SystemUiOverlayStyle(
            //     statusBarColor: MyColors.background,
            //     statusBarIconBrightness: Brightness.dark,
            //     statusBarBrightness: Brightness.dark),
            backgroundColor: MyColors.background,
            foregroundColor: MyColors.secondary,
            title: const Text(
              "Evaluate an Academic",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
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
                        child: submitting
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  postEvaluation();
                                },
                                style: ElevatedButton.styleFrom(
                                  enableFeedback: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  // fixedSize:
                                  //     Size(MediaQuery.of(context).size.width * 0.5, 50),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: const Text("Post Evaluation"),
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
                    fontSize: 12,
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
                  EdgeInsets.symmetric(horizontal: field.hasError ? 5 : 15),
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
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: MyColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildRadioButtons1(index),
            ),

            // SEPERATOR
            index != labels.length - 1
                ? const SizedBox(
                    height: 60,
                    child: Divider(thickness: 2),
                  )
                : SizedBox(),
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
        validator: (value) {
          return radio2Vals[index] == 0 ? "Required" : null;
        },
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                      style: const TextStyle(
                        fontSize: 18.0,
                        // height: 0.9,
                        fontWeight: FontWeight.w500,
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
        const Padding(
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
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
              controller: _remarkController,
              maxLines: 6,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  hintText: "Type Here...",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: MyColors.primaryVariant, width: 2),
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

  postEvaluation() async {
    print("IM PRESSED");
    bool isValid = _formKey.currentState!.validate();
    // _focusRadio.requestFocus();
    print("Form valid: $isValid");
    if (!isValid) {
      showSnackBar(context, "Please fill out all the required fields.");
    } else {
      print(widget.academic);
      print("Radio 1: $radio1Vals");
      print("Radio 2: $radio2Vals");
      print("Remark: ${_remarkController.text}");
      setState(() {
        submitting = true;
      });
      var res = await Requests.evaluateCourse(widget.academic['value'],
          radio1Vals, radio2Vals, _remarkController.text);
      setState(() {
        submitting = false;
      });
      showSnackBar(context, res['message']);
    }
  }

  bool submitting = false;

  @override
  bool get wantKeepAlive => true;
}
