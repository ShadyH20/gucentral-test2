import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import 'package:data_table_2/data_table_2.dart';
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";

import "../widgets/Requests.dart";

class TranscriptPage extends StatefulWidget {
  String gpa;
  TranscriptPage({super.key, required this.gpa});

  @override
  // ignore: no_logic_in_create_state
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  // String gpa = "";
  bool showLoading = false;
  var semesterGrades = [];

  void updateTranscript() async {
    setState(() {
      showLoading = true;
    });
    var output = await Requests.getTranscript(context);
    setState(() {
      showLoading = false;
      // widget.gpa = "3.14";
      semesterGrades = output['transcript'];
      print("Set state: $semesterGrades");
    });
    // build(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: MyColors.background,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark),
        elevation: 0,
        backgroundColor: MyColors.background,
        centerTitle: true,
        leadingWidth: 50.0,
        leading: const MenuWidget(),
        title: const Text(
          "Transcript",
          style: TextStyle(color: MyColors.primary),
        ),
        actions: [
          IconButton(
            splashRadius: 15,
            // padding: EdgeInsets.symmetric(horizontal: 20.0),
            icon:
                const Icon(Icons.refresh, color: MyColors.secondary, size: 35),
            onPressed: () {
              updateTranscript();
            },
          ),
          Container(
            width: 10,
          )
        ],
      ),
      body: Container(
        // color: MyColors.accent,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: showLoading
            ? loading()
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 100),
                  Container(
                    alignment: Alignment.center,
                    width: 200.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                      color: MyColors.background,
                      boxShadow: const [
                        BoxShadow(color: MyColors.primary, offset: Offset(0, 2))
                      ],
                    ),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text.rich(
                        TextSpan(
                          text: widget.gpa,
                          style: const TextStyle(
                              color: MyColors.secondary,
                              fontSize: 72,
                              fontWeight: FontWeight.w900),
                          children: const [
                            TextSpan(
                              text: "GPA",
                              style: TextStyle(
                                  // color: MyColors.background,
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(height: 50),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      // width: 380,
                      height: 400,
                      child: Column(
                        children: [
                          semesterGrades.isNotEmpty
                              ? Expanded(child: createTables())
                              : const Text("Nothing Here!"),
                        ],
                      ),
                      // ),
                    ),
                  ),
                  // Container(
                  //   height: 30,
                  // )
                ],
              ),
      ),
    );
  }

  Widget createTables() {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: semesterGrades.length,
        itemBuilder: (BuildContext context, int index) {
          var semester = semesterGrades[index];
          var semesterName = semester[0];
          var courseGrades = semester[1];

          // Create a list of DataRows for each course grade
          var rows = <DataRow>[
            for (var grade in courseGrades.take(courseGrades.length - 1))
              DataRow(cells: [
                DataCell(Text(grade[0])), // Course name
                DataCell(Text(grade[1])), // Grade
                DataCell(Text(grade[2].toString())), // Credits
              ])
          ];

          // Create a DataTable for the current semester
          return Column(
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  semesterName ?? "",
                  style: const TextStyle(
                      color: MyColors.primary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: MyColors.background,
                  boxShadow: const [
                    BoxShadow(color: MyColors.primary, offset: Offset(0, -2))
                  ],
                ),
                child: DataTable(
                  headingRowHeight: 0,
                  showBottomBorder: true,
                  dividerThickness: 2,
                  // border: TableBorder(
                  //     horizontalInside: BorderSide(
                  //         color: MyColors.secondary
                  //             .withOpacity(.5))),
                  columnSpacing: 25,
                  dataRowHeight: 30,
                  horizontalMargin: 3,
                  dataTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      letterSpacing: .1,
                      color: MyColors.secondary),
                  columns: const [
                    DataColumn2(label: Text('Course Name'), size: ColumnSize.L),
                    DataColumn(label: Text('')),
                    DataColumn2(label: Text(''), numeric: true),
                  ],
                  rows: rows,
                ),
              ),
              Align(
                alignment: const FractionalOffset(0.96, 0.0),
                child: Text.rich(
                  // textAlign: TextAlign.end,
                  TextSpan(
                    text: courseGrades[courseGrades.length - 1][0].toString(),
                    style: const TextStyle(
                        color: MyColors.secondary,
                        fontSize: 17,
                        fontWeight: FontWeight.w900),
                    children: const [
                      TextSpan(
                        text: "GPA",
                        style: TextStyle(
                            // color: MyColors.background,
                            fontSize: 10,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              Container(height: 15)
            ],
          );
        },
      ),
    );
  }

  loading() {
    return const SizedBox(
      width: 70,
      height: 70,
      child: CircularProgressIndicator(
        strokeWidth: 7,
        color: MyColors.accent,
        backgroundColor: MyColors.primary,
      ),
    );
  }
}

// Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(
//                           25.0,
//                         ),
//                         color: MyColors.background,
//                         boxShadow: const [
//                           BoxShadow(
//                               color: MyColors.primary, offset: Offset(0, -2))
//                         ],
//                       ),
//                       // height: 300.0,
//                       child: DataTable(
//                         headingRowHeight: 0,
//                         showBottomBorder: true,
//                         dividerThickness: 2,
//                         // border: TableBorder(
//                         //     horizontalInside: BorderSide(
//                         //         color: MyColors.secondary
//                         //             .withOpacity(.5))),
//                         columnSpacing: 25,
//                         dataRowHeight: 30,
//                         horizontalMargin: 3,
//                         dataTextStyle: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             letterSpacing: .1,
//                             color: MyColors.secondary),
//                         columns: const [
//                           // column to set the name
//                           DataColumn(label: Text("dsfsdf")),
//                           DataColumn(label: Text(""), numeric: true),
//                           DataColumn(label: Text(""), numeric: true),
//                         ],
//                         rows: const [
//                           DataRow(cells: [
//                             DataCell(Text("Mathematics V (Discrete Math)")),
//                             DataCell(Text("A")),
//                             DataCell(Text("4")),
//                           ]),
//                           DataRow(cells: [
//                             DataCell(Text("Introduction to Media Engineering")),
//                             DataCell(Text("A")),
//                             DataCell(Text("4")),
//                           ]),
//                           DataRow(cells: [
//                             DataCell(
//                                 Text("Introduction to Communication Networks")),
//                             DataCell(Text("A")),
//                             DataCell(Text("4")),
//                           ]),
//                         ],
//                       ),
//                     // ),
