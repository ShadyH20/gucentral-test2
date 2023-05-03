// ignore_for_file: avoid_print

import "dart:convert";
import "dart:ui";
import "package:dropdown_button2/dropdown_button2.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import 'package:data_table_2/data_table_2.dart';
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import 'package:simple_animations/simple_animations.dart';
import 'package:all_sensors/all_sensors.dart';
import "package:shared_preferences/shared_preferences.dart";

import "../main.dart";
import "../utils/SharedPrefs.dart";
import "../widgets/Requests.dart";

bool showGPA = false;

class TranscriptPage extends StatefulWidget {
  bool firstAccess = true;
  // var semesterGrades = [];
  TranscriptPage({super.key});

  void hideGPA() {
    // showGPA = false;
  }

  @override
  // ignore: no_logic_in_create_state
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  String gpa = "";
  bool showLoading = false;
  List<dynamic>? semesterGrades;
  bool tiltingBack = false;

  @override
  void initState() {
    super.initState();
    getUsernameId();
    if (semesterGrades == null) {
      initalizePage();
      setState(() {});
    }

    gyroscopeEvents?.listen((GyroscopeEvent event) {
      if (event.x > 3.0) {
        setState(() {
          tiltingBack = true;
        });
      } else if (tiltingBack && event.x < -3.0) {
        setState(() {
          tiltingBack = false;
          showGPA = !showGPA;
        });
        print("SWITCH!!!");
      }
    });
  }

  void initalizePage() {
    // print("Initialize transcript, 2D array: $semesterGrades");
    if (prefs.containsKey('gpa')) {
      gpa = prefs.getString('gpa')!;
      int currYear = DateTime.now().year;
      // String lastOption = "$currYear-${currYear + 1}";
      int batch = int.parse((usernameId[1] as String).split("-")[0]);
      int firstYear = ((batch - 1) / 3 + 2003).toInt();
      // int lastYear = int.parse(lastOption.split("-")[0]);
      list = [];
      int i = 1;
      while (firstYear < currYear) {
        list.add({
          'value': "$firstYear-${firstYear + 1}",
          'text': '${getYearText(i)} Year'
        }); // ignore: prefer_collection_literals});
        firstYear++;
        i++;
      }
    }
    if (widget.firstAccess) {
      // updateTranscript();
      setState(() {
        widget.firstAccess = false;
      });
    }
  }

  getYearText(int num) {
    // returns the number with the ranking suffix i.e 1st, 2nd, 3rd, 4th, etc.
    // should handle multiple digit numbers as well
    if (num % 100 >= 11 && num % 100 <= 13) {
      return "${num}th";
    }
    switch (num % 10) {
      case 1:
        return "${num}st";
      case 2:
        return "${num}nd";
      case 3:
        return "${num}rd";
      default:
        return "${num}th";
    }
  }

  void updateTranscript(dynamic year) async {
    // loading
    setState(() {
      showLoading = true;
    });
    print("Updating transcript for $year");

    // get the transcript
    var output = await Requests.getTranscript(context, year);
    setState(() {
      showLoading = false;
    });

    // if success if false
    if (!output['success']) {
      showSnackBar(context, 'An error ocurred! Please try again.');
      return;
    }

    // if success is true
    setState(() {
      semesterGrades = output['transcript'];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldMessenger(
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: MyColors.background,
          appBar: transcriptAppBar(),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // #####################
              // #### ACTUAL PAGE ####
              // #####################
              children: [
                const Spacer(),
                profile(),
                const Spacer(),
                cumulativeGPA(),
                const Spacer(),
                buildDropdown(),
                const Spacer(),
                Expanded(
                  flex: 10,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    // width: 380,
                    // height: 350,
                    child: Column(
                      children: [
                        showLoading
                            ? ListView.separated(
                                itemBuilder: (context, index) =>
                                    const SemesterSkeleton(),
                                separatorBuilder: (context, index) =>
                                    Container(height: 25),
                                itemCount: 2,
                                shrinkWrap: true,
                              )
                            : (semesterGrades == null ||
                                    semesterGrades!.isEmpty)
                                ? const Text("Nothing Here!")
                                : Expanded(child: createTables()),
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
      }),
    );
  }

// ############################
// ####### PAGE WIDGETS #######
// ############################

  // ####### APP BAR #######
  AppBar transcriptAppBar() {
    return AppBar(
      // systemOverlayStyle: SystemUiOverlayStyle(
      //     statusBarColor: MyColors.background,
      //     statusBarIconBrightness: Brightness.dark,
      //     statusBarBrightness: Brightness.dark),
      elevation: 0,
      backgroundColor: MyColors.background,
      centerTitle: true,
      leadingWidth: 60.0,
      leading: const MenuWidget(),
      title: const Text(
        "Transcript",
        // style: TextStyle(color: MyColors.primary),
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
            updateTranscript(dropdownValue ?? "");
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
        boxShadow: [
          BoxShadow(
              color: MyColors.primary,
              offset: const Offset(0, 2),
              spreadRadius: 0.3)
        ],
      ),
      child: Column(
        children: [
          Text(
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
                  style: TextStyle(
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
  getUsernameId() {
    var out = Requests.getUsernameId();
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
      physics: const BouncingScrollPhysics(),
      child: ListView.separated(
        // controller: _scrollController,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => Container(height: 15),
        itemCount: semesterGrades != null ? semesterGrades!.length : 0,
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
                  style: TextStyle(
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
                      boxShadow: [
                        BoxShadow(
                            color: MyColors.primary,
                            offset: const Offset(0, -2))
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constrains) => DataTable(
                        headingRowHeight: 0,
                        showBottomBorder: true,
                        dividerThickness: 2,
                        // border: TableBorder(
                        //     horizontalInside: BorderSide(
                        //         color: MyColors.secondary
                        //             .withOpacity(.5))),
                        columnSpacing: 0,
                        dataRowHeight: 30,
                        horizontalMargin: 3,
                        dataTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                            letterSpacing: .1,
                            color: MyColors.secondary),
                        columns: [
                          DataColumn2(
                              label: SizedBox(
                                  width: (constrains.maxWidth - 10) * 0.85,
                                  child: const Text('Course Name')),
                              size: ColumnSize.L),
                          DataColumn(
                              label: SizedBox(
                                  width: (constrains.maxWidth - 10) * 0.05,
                                  child: const Text(''))),
                          DataColumn2(
                              label: SizedBox(
                                  width: (constrains.maxWidth - 10) * 0.05,
                                  child: const Text('')),
                              numeric: true),
                        ],
                        rows: rows,
                      ),
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
                          style: TextStyle(
                              color: MyColors.secondary,
                              fontSize: 17,
                              fontWeight: FontWeight.w900),
                          children: const [
                            TextSpan(
                              text: " GPA",
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
            ],
          );
        },
      ),
    );
  }

  late List<Map<String, String>> list;

  dynamic dropdownValue;
  buildDropdown() {
    return Container(
      width: 180,
      height: 40,
      padding: const EdgeInsets.only(left: 0),
      decoration: BoxDecoration(
          color: MyApp.isDarkMode.value
              ? MyColors.surface
              : const Color.fromARGB(255, 230, 230, 230),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          iconStyleData: const IconStyleData(
              icon: Icon(Icons.arrow_drop_down_outlined), iconSize: 30),
          isExpanded: true,
          value: dropdownValue,
          style: TextStyle(
              color: MyApp.isDarkMode.value ? Colors.white70 : Colors.black54,
              fontFamily: 'Outfit',
              fontSize: 18,
              fontWeight: FontWeight.bold),
          dropdownStyleData: const DropdownStyleData(
              offset: Offset(0, 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              )),
          hint: Text("Select A Year"),
          alignment: Alignment.centerRight,
          onChanged: (dynamic value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
            updateTranscript(value!);
          },
          items: list.map<DropdownMenuItem<dynamic>>((dynamic year) {
            return DropdownMenuItem<dynamic>(
              value: year['value'],
              child: Center(child: Text(year['text'])),
            );
          }).toList(),
        ),
      ),
    );
  }

  loading() {
    return SizedBox(
      width: 70,
      height: 70,
      child: CircularProgressIndicator(
        strokeWidth: 7,
        color: MyColors.tertiary,
        backgroundColor: MyColors.primary,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SemesterSkeleton extends StatelessWidget {
  const SemesterSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MirrorAnimationBuilder<double>(
      duration: const Duration(seconds: 1, milliseconds: 200),
      tween: Tween(begin: 1, end: 0.2),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Column(
          children: [
            const Skeleton(
              width: 150,
              height: 25,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: List.generate(
                    6,
                    (i) => Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Skeleton(width: 290, height: 15),
                                  Skeleton(width: 25, height: 15),
                                  Skeleton(width: 25, height: 15),
                                ]),
                            const SizedBox(height: 13)
                          ],
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DROPDOWN LIST CLASS

// class DropdownButtonYears extends StatefulWidget {
//   _TranscriptPageState transcript;
//   DropdownButtonYears({super.key, required this.transcript});

//   @override
//   State<DropdownButtonYears> createState() => _DropdownButtonYearsState();
// }

// class _DropdownButtonYearsState extends State<DropdownButtonYears> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 180,
//       height: 40,
//       padding: const EdgeInsets.only(left: 10),
//       decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 230, 230, 230),
//           borderRadius: BorderRadius.circular(10)),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton2(
//           iconStyleData: const IconStyleData(
//               icon: Icon(Icons.arrow_drop_down_outlined), iconSize: 30),
//           isExpanded: true,
//           value: dropdownValue,
//           style: const TextStyle(
//               // decoration: TextDecoration.underline,
//               color: Colors.black54,
//               fontFamily: 'Outfit',
//               fontSize: 18,
//               fontWeight: FontWeight.bold),
//           // dropdownColor: MyColors.secondary,
//           dropdownStyleData: DropdownStyleData(
//               decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//           )),
//           underline: Container(
//             color: Colors.transparent,
//           ),
//           hint: const Text("Select A Year"),

//           onChanged: (String? value) {
//             // This is called when the user selects an item.
//             setState(() {
//               dropdownValue = value!;
//             });
//             if (dropdownValue != list.first) {
//               widget.transcript.updateTranscript(value!);
//             }
//           },
//           items: list.map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Center(child: Text(value)),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height,
  });

  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: MyApp.isDarkMode.value
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16)),
    );
  }
}
