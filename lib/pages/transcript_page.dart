import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import 'package:data_table_2/data_table_2.dart';
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:http/http.dart" as http;

class TranscriptPage extends StatefulWidget {
  final String gpa;
  const TranscriptPage({super.key, required this.gpa});

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
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
              // padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: SvgPicture.asset(
                "assets/images/edit.svg",
                height: 30,
                // color: MyColors.secondary,
              ),
              onPressed: () {},
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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    child: const Text.rich(
                      TextSpan(
                        text: "1.37",
                        style: TextStyle(
                            color: MyColors.secondary,
                            fontSize: 72,
                            fontWeight: FontWeight.w900),
                        children: [
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
                  Container(height: 100.0),
                  Container(
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
                      width: 370.0,
                      // height: 300.0,
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            DataTable(
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
                                    fontSize: 12,
                                    letterSpacing: .1,
                                    color: MyColors.secondary),
                                columns: const [
                                  // column to set the name
                                  DataColumn(label: Text("dsfsdf")),
                                  DataColumn(label: Text(""), numeric: true),
                                  DataColumn(label: Text(""), numeric: true),
                                ],
                                rows: const [
                                  DataRow(cells: [
                                    DataCell(
                                        Text("Mathematics V (Discrete Math)")),
                                    DataCell(Text("A")),
                                    DataCell(Text("4")),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                        "Introduction to Media Engineering")),
                                    DataCell(Text("A")),
                                    DataCell(Text("4")),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                        "Introduction to Communication Networks")),
                                    DataCell(Text("A")),
                                    DataCell(Text("4")),
                                  ]),
                                  // DataRow(cells: [
                                  //   DataCell(Text("Introduction to Media Engineering")),
                                  //   DataCell(Text("Introduction to Media Engineering")),
                                  //   DataCell(Text("Introduction to Communication Networks")),
                                  //   DataCell(Text("Theory of Computation")),
                                  // ]),
                                  // DataRow(cells: [
                                  //   DataCell(Text("Mathematics V (Discrete Math)")),
                                  //   DataCell(Text("Introduction to Media Engineering")),
                                  //   DataCell(
                                  //       Text("Introduction to Communication Networks")),
                                  //   DataCell(Text("Theory of Computation")),
                                  // ])
                                ]),
                          ]))
                ])));
  }
}
