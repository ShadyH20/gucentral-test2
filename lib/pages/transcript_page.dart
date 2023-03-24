// ignore_for_file: avoid_print

import "dart:convert";
import "dart:ui";
import "package:dropdown_button2/dropdown_button2.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import 'package:data_table_2/data_table_2.dart';
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
// import "package:sensors_plus/sensors_plus.dart";
// // import 'package:sensors_plus_web/sensors_plus_web.dart';
import 'package:all_sensors/all_sensors.dart';
import "package:shared_preferences/shared_preferences.dart";

import "../widgets/Requests.dart";

bool showGPA = false;

class TranscriptPage extends StatefulWidget {
  bool firstAccess = true;
  // var semesterGrades = [];
  TranscriptPage({super.key});

  void hideGPA() {
    showGPA = false;
  }

  @override
  // ignore: no_logic_in_create_state
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  String gpa = "";
  String last_option = "";
  bool showLoading = false;
  List<dynamic>? semesterGrades;
  bool tiltingBack = false;

  _TranscriptPageState() {
    getUsernameId();
  }

  @override
  void initState() {
    super.initState();

    gyroscopeEvents?.listen((GyroscopeEvent event) {
      if (event.x > 2.0) {
        setState(() {
          tiltingBack = true;
        });
      } else if (tiltingBack && event.x < -2.0) {
        setState(() {
          tiltingBack = false;
          showGPA = !showGPA;
        });
        print("SWITCH!!!");
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (semesterGrades == null) {
      initalizePage();
      setState(() {});
    }
  }

  void initalizePage() async {
    // print("Initialize transcript, 2D array: $semesterGrades");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('gpa')) {
      setState(() {
        gpa = prefs.getString('gpa')!;
        last_option = prefs.getString('last_option')!;
      });

      if (last_option != "") {
        int batch = int.parse((usernameId[1] as String).split("-")[0]);
        int firstYear = ((batch - 1) / 3 + 2003) as int;
        int lastYear = int.parse(last_option.split("-")[0]);
        while (firstYear <= lastYear) {
          list.add("$firstYear-${firstYear + 1}");
          firstYear++;
        }
      }
    }
    if (widget.firstAccess) {
      // updateTranscript();
      setState(() {
        widget.firstAccess = false;
      });
    }
  }

  void updateTranscript(String year) async {
    setState(() {
      showLoading = true;
    });
    var output = await Requests.getTranscript(context, year);
    setState(() {
      showLoading = false;
      // widget.gpa = "3.14";
      semesterGrades = output['transcript'];
      // print("Set state: $semesterGrades");
    });
    // build(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: transcriptAppBar(),
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

                // #####################
                // #### ACTUAL PAGE ####
                // #####################
                children: [
                  Container(),
                  profile(),
                  // Container(height: 10),
                  cumulativeGPA(),
                  // Container(height: 30),
                  DropdownButtonYears(transcript: this),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      // width: 380,
                      height: 350,
                      child: Column(
                        children: [
                          semesterGrades != null
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

// ############################
// ####### PAGE WIDGETS #######
// ############################

  // ####### APP BAR #######
  AppBar transcriptAppBar() {
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
        "Transcript",
        style: TextStyle(color: MyColors.primary),
      ),
      actions: [
        IconButton(
          splashRadius: 15,
          // padding: EdgeInsets.symmetric(horizontal: 20.0),
          icon: Icon(showGPA ? Icons.visibility : Icons.visibility_off,
              color: MyColors.secondary, size: 35),
          onPressed: () {
            setState(() {
              showGPA = !showGPA;
            });
          },
        ),
        IconButton(
          splashRadius: 15,
          // padding: EdgeInsets.symmetric(horizontal: 20.0),
          icon: SvgPicture.asset(
            "assets/images/refresh.svg",
            height: 24,
            color: MyColors.secondary,
          ),
          onPressed: () {
            updateTranscript(dropdownValue);
          },
        ),
        Container(
          width: 10,
        )
      ],
    );
  }

  // ### CUMULATIVE GPA ####
  Widget cumulativeGPA() {
    return Container(
      alignment: Alignment.center,
      width: 200.0,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
        color: MyColors.background,
        boxShadow: const [
          BoxShadow(
              color: MyColors.primary, offset: Offset(0, 2), spreadRadius: 0.3)
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Cumulative",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: MyColors.primaryVariant),
          ),
          ImageFiltered(
            enabled: !showGPA,
            imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text.rich(
                TextSpan(
                  text: gpa,
                  style: const TextStyle(
                      color: MyColors.secondary,
                      fontSize: 72,
                      fontWeight: FontWeight.w800),
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
        ],
      ),
    );
  }

  // ####### PROFILE #######
  List<dynamic> usernameId = [];
  getUsernameId() async {
    var out = await Requests.getUsernameId();
    setState(() {
      usernameId = out;
    });
  }

  Widget profile() {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/images/profile.svg",
          height: 95,
        ),
        const SizedBox(height: 5),
        Text(
          usernameId[0],
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
        Text(
          usernameId[1],
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  Future<List> getUsernameAndID() {
    return getUsernameAndIDHelper();
  }

  Future<List> getUsernameAndIDHelper() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return [prefs.getString('username'), prefs.getString('id')];
  }

// ###########################
// ######### METHODS #########
// ###########################
  Widget createTables() {
    return SingleChildScrollView(
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: semesterGrades?.length,
        itemBuilder: (BuildContext context, int index) {
          var semester = semesterGrades?[index];
          var semesterName = semester[0];
          var courseGrades = semester[1];

          // Create a list of DataRows for each course grade
          var rows = <DataRow>[
            for (var grade in courseGrades.take(courseGrades.length - 1))
              DataRow(cells: [
                DataCell(Text(grade[0])), // Course name
                DataCell(ImageFiltered(
                    enabled: !showGPA,
                    imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    //sigmaX: 7, sigmaY: 7, tileMode: TileMode.decal),
                    child: Text(grade[1]))), // Grade
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
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: MyColors.background,
                      boxShadow: const [
                        BoxShadow(
                            color: MyColors.primary, offset: Offset(0, -2))
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
                        DataColumn2(
                            label: Text('Course Name'), size: ColumnSize.L),
                        DataColumn(label: Text(' ')),
                        DataColumn2(label: Text(''), numeric: true),
                      ],
                      rows: rows,
                    ),
                  ),
                  Align(
                    alignment: const FractionalOffset(0.96, 0.0),
                    child: ImageFiltered(
                      imageFilter: showGPA
                          ? ImageFilter.blur()
                          : ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                      child: Text.rich(
                        // textAlign: TextAlign.end,
                        TextSpan(
                          text: courseGrades[courseGrades.length - 1][0]
                              .toString(),
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
                  ),
                ],
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

  @override
  bool get wantKeepAlive => true;
}

// DROPDOWN LIST CLASS

const List<String> list = <String>[
  'Select A Year',
  // '2019-2020',
  // '2020-2021',
  // '2021-2022',
  // '2022-2023'
];

String dropdownValue = list.first;

class DropdownButtonYears extends StatefulWidget {
  _TranscriptPageState transcript;
  DropdownButtonYears({super.key, required this.transcript});

  @override
  State<DropdownButtonYears> createState() => _DropdownButtonYearsState();
}

class _DropdownButtonYearsState extends State<DropdownButtonYears> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 40,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 230, 230, 230),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          iconStyleData: const IconStyleData(
              icon: Icon(Icons.arrow_drop_down_outlined), iconSize: 30),
          isExpanded: true,
          value: dropdownValue,
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

          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
            if (dropdownValue != list.first) {
              widget.transcript.updateTranscript(value!);
            }
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(child: Text(value)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
