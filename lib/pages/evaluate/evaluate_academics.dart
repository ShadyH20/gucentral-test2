import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gucentral/pages/evaluate/evaluate_an_academic.dart';
import 'package:http/http.dart';
import 'package:ntlm/ntlm.dart';

import '../../main.dart';
import '../../widgets/MyColors.dart';
import '../../widgets/Requests.dart';

class EvaluateAcademics extends StatefulWidget {
  const EvaluateAcademics({super.key});

  @override
  State<EvaluateAcademics> createState() => _EvaluateAcademicsState();
}

class _EvaluateAcademicsState extends State<EvaluateAcademics>
    with AutomaticKeepAliveClientMixin<EvaluateAcademics> {
  // ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  bool loading = false;
  List academicsToEval = [];

  @override
  void initState() {
    super.initState();
    initAcademicsToEval();
  }

  void initAcademicsToEval() async {
    setState(() {
      loading = true;
    });
    var resp = await Requests.getAcademicsToEval();
    if (resp['success']) {
      setState(() {
        academicsToEval = [];
        academicsToEval += (resp['academics']);
      });
      debugPrint(academicsToEval.toString());
    } else {
      showSnackBar(context, resp['message']);
    }
    setState(() {
      loading = false;
    });
  }

  dynamic dropdownAcademicValue;
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
                        "Academics To Evaluate",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 55,
                        // padding: const EdgeInsets.only(left: 0),
                        decoration: BoxDecoration(
                            color: context.isDarkMode
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

                            value: dropdownAcademicValue,
                            style: TextStyle(
                                // decoration: TextDecoration.underline,
                                color: context.isDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            // dropdownColor: MyColors.secondary,

                            dropdownStyleData: DropdownStyleData(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.5,
                                offset: const Offset(0, 4),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                )),
                            menuItemStyleData: MenuItemStyleData(
                              selectedMenuItemBuilder: (context, child) =>
                                  DefaultTextStyle(
                                style: TextStyle(
                                  color: MyColors.secondary,
                                  fontFamily: 'Outfit',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                child: child,
                              ),
                            ),
                            hint: const Text("Choose a Staff Member"),
                            onChanged: (academic) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownAcademicValue = academic;
                              });
                              debugPrint("$dropdownAcademicValue chosen");
                              academicChosen(context, academic);
                              // widget.transcript.updateTranscript(value!);
                            },
                            items: academicsToEval
                                .map<DropdownMenuItem>((dynamic academic) {
                              return DropdownMenuItem(
                                value: academic,
                                child: Text(academic['name']),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: isAcademicLoaded ? 10 : 0),

                      /// if the user has chosen a staff member to evaluate
                      Expanded(
                        child: isAcademicLoading
                            ? const Center(child: CircularProgressIndicator())
                            : isAcademicLoaded
                                ? EvaluateAnAcademic(
                                    academic: dropdownAcademicValue)
                                : const SizedBox(),
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  bool isAcademicLoading = false;
  bool isAcademicLoaded = false;
  void academicChosen(context, academic) async {
    if (academic['value'] == "-1") return;
    setState(() => isAcademicLoading = true);
    // setState(() => loading = true);
    var resp = await Requests.checkAcademicEvaluated(academic['value']);
    var alreadyEvaluated = !resp['success'];
    setState(() {
      isAcademicLoading = false;
      isAcademicLoaded = !alreadyEvaluated;
    });
    if (alreadyEvaluated) {
      showSnackBar(context, resp['message'],
          duration: const Duration(seconds: 7));
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
