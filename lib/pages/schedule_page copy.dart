import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:http/http.dart" as http;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// import 'package:navigation_drawer_animation/widet/menu_widget'

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
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
          "Schedule",
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
        // androidlarge4Ds2 (15:313)
        padding: EdgeInsets.fromLTRB(0, 178, 0, 0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(100),
        ),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // daysyFr (15:399)
                  margin: EdgeInsets.fromLTRB(65, 0, 65, 0),
                  width: double.infinity,
                  height: 295,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // dayblockf8g (15:389)
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                        padding: EdgeInsets.fromLTRB(51, 48, 50, 48),
                        width: 212,
                        height: 291,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          // dateKj2 (15:391)
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // eWQ (15:392)
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                                child: Text(
                                  '23',
                                  style: TextStyle(
                                    fontSize: 100,
                                    fontWeight: FontWeight.w600,
                                    height: 1.26,
                                    color: Color(0xff272932),
                                  ),
                                ),
                              ),
                              Center(
                                // thuY5z (15:393)
                                child: Text(
                                  'thu',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w300,
                                    height: 1.26,
                                    color: Color(0xff272932),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 94,
                      ),
                      Container(
                        // dayblockbpx (15:384)
                        margin: EdgeInsets.fromLTRB(0, 3, 0, 1),
                        padding: EdgeInsets.fromLTRB(51, 48, 45, 48),
                        width: 212,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          // dateGw6 (15:386)
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // pBv (15:387)
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                                child: Text(
                                  '24',
                                  style: TextStyle(
                                    fontSize: 100,
                                    fontWeight: FontWeight.w600,
                                    height: 1.26,
                                    color: Color(0xff272932),
                                  ),
                                ),
                              ),
                              Center(
                                // friiHJ (15:388)
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                  child: Text(
                                    'fri',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w300,
                                      height: 1.26,
                                      color: Color(0xff272932),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 94,
                      ),
                      Container(
                        // dayblockyj2 (15:377)
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                        padding: EdgeInsets.fromLTRB(51, 29, 50, 33),
                        width: 212,
                        height: 291,
                        decoration: BoxDecoration(
                          color: Color(0xfff66f51),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          // dates3i (15:378)
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // autogroupiyuu1Qp (D1cFPCF2QGXcxc7fGviYUU)
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                                width: double.infinity,
                                height: 163,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      // 7Cx (15:374)
                                      left: 0,
                                      top: 37,
                                      child: Align(
                                        child: SizedBox(
                                          width: 111,
                                          height: 126,
                                          child: Text(
                                            '25',
                                            style: TextStyle(
                                              fontSize: 100,
                                              fontWeight: FontWeight.w600,
                                              height: 1.26,
                                              color: Color(0xfffcfcfc),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      // iconsmoJ (16:410)
                                      left: 26.666015625,
                                      top: 0,
                                      child: Container(
                                        width: 58.33,
                                        height: 38,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              // deadlineg9a (16:415)
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 9.33, 0),
                                              width: 24,
                                              height: 30,
                                              child: SvgPicture.asset(
                                                "assets/images/deadline-new.svg",
                                                height: 15,
                                                color: MyColors.background,
                                              ),
                                            ),
                                            Text(
                                              // qAaY (16:411)
                                              'Q',
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w800,
                                                height: 1.26,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                // satV72 (15:375)
                                'sat',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w300,
                                  height: 1.26,
                                  color: Color(0xfffcfcfc),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 94,
                      ),
                      Opacity(
                        // dayblockzZa (15:379)
                        opacity: 0.7,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 1, 0, 3),
                          padding: EdgeInsets.fromLTRB(51, 14.33, 48, 48),
                          width: 212,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // deadline2WG (16:412)
                                margin: EdgeInsets.fromLTRB(0, 0, 3, 0.33),
                                width: 26.67,
                                height: 33.33,
                                child: SvgPicture.asset(
                                  "assets/images/deadline-new.svg",
                                  height: 15,
                                  color: MyColors.background,
                                ),
                              ),
                              Container(
                                // date7Gp (15:381)
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // EsE (15:382)
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                                      child: Text(
                                        '26',
                                        style: TextStyle(
                                          fontSize: 100,
                                          fontWeight: FontWeight.w600,
                                          height: 1.26,
                                          color: Color(0xff272932),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      // suniXW (15:383)
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                        child: Text(
                                          'sun',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.w300,
                                            height: 1.26,
                                            color: Color(0xff272932),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 94,
                      ),
                      Container(
                        // dayblockNrx (15:394)
                        margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                        padding: EdgeInsets.fromLTRB(51, 48, 55, 48),
                        width: 212,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          // dater1S (15:396)
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                // nQt (15:397)
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                                child: Text(
                                  '27',
                                  style: TextStyle(
                                    fontSize: 100,
                                    fontWeight: FontWeight.w600,
                                    height: 1.26,
                                    color: Color(0xff272932),
                                  ),
                                ),
                              ),
                              Center(
                                // monV4Q (15:398)
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    'mon',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w300,
                                      height: 1.26,
                                      color: Color(0xff272932),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // autogroupefunnpC (D1c4oFP1hqkrZVTHZGEfuN)
                  padding: EdgeInsets.fromLTRB(102, 37, 0, 59),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // eventsectionJXe (17:471)
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 77),
                        width: 1563,
                        height: 326,
                        child: Stack(
                          children: [
                            Positioned(
                              // alloptionsbme (17:464)
                              left: 2,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 21, 0, 21),
                                width: 162,
                                height: 113,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0x3f000000)),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Opacity(
                                      // optionEJp (17:460)
                                      opacity: 0.5,
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 20, 0),
                                        padding: EdgeInsets.fromLTRB(
                                            20.07, 16.21, 20.06, 16.21),
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0xffd4d4d6),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Center(
                                          // deadlinegRi (17:459)
                                          child: SizedBox(
                                            width: 30.87,
                                            height: 38.59,
                                            child: SvgPicture.asset(
                                              "assets/images/deadline-new.svg",
                                              height: 15,
                                              color: MyColors.background,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // optionN3e (17:465)
                                      width: 71,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color(0xffd4d4d6),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Q',
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w800,
                                            height: 1.26,
                                            color: Color(0xff272932),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              // quizzesQm2 (17:477)
                              left: 2,
                              top: 21,
                              child: Container(
                                width: 1118,
                                height: 291,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // optionactiveW3N (17:482)
                                      margin: EdgeInsets.fromLTRB(91, 0, 0, 41),
                                      width: 71,
                                      height: 71,
                                      decoration: BoxDecoration(
                                        color: Color(0xfff66f51),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Q',
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w800,
                                            height: 1.26,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // autogroupktzc96L (D1cAeL91wxJtzCgzoMKTzC)
                                      width: double.infinity,
                                      height: 179,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // quizboxU8c (17:473)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 32, 0),
                                            width: 543,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Color(0xfff66f51),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  // textZA4 (17:476)
                                                  left: 27,
                                                  top: 16,
                                                  child: Container(
                                                    width: 462,
                                                    height: 142.5,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          // autogroupdi9s4cc (D1cAtzPFtib3Qs4RH7di9S)
                                                          margin: EdgeInsets
                                                              .fromLTRB(0, 0, 0,
                                                                  11.5),
                                                          width:
                                                              double.infinity,
                                                          height: 93,
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                // quiziAvY (17:489)
                                                                left: 0,
                                                                top: 42,
                                                                child: Align(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 106,
                                                                    height: 51,
                                                                    child: Text(
                                                                      'Quiz I',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            40,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        height:
                                                                            1.26,
                                                                        color: Color(
                                                                            0xffffffff),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                // networksandmedialabd3S (17:474)
                                                                left: 0,
                                                                top: 0,
                                                                child: Align(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 462,
                                                                    height: 51,
                                                                    child: Text(
                                                                      'Networks and Media Lab',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            40,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        height:
                                                                            1.26,
                                                                        color: Color(
                                                                            0xffffffff),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          // inlecture5w2 (17:475)
                                                          'In Lecture',
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            height: 1.26,
                                                            color: Color(
                                                                0xffffffff),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  // locationDXS (19:962)
                                                  left: 437,
                                                  top: 123,
                                                  child: Container(
                                                    width: 77,
                                                    height: 38,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          // locationWWY (19:964)
                                                          margin: EdgeInsets
                                                              .fromLTRB(0, 1,
                                                                  11.09, 0),
                                                          width: 16.91,
                                                          height: 25,
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/images/location.svg",
                                                            height: 15,
                                                            color: MyColors
                                                                .secondary,
                                                          ),
                                                        ),
                                                        Text(
                                                          // h19oVe (19:963)
                                                          'H19',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.26,
                                                            color: Color(
                                                                0xffffffff),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // quizboxgZS (17:490)
                                            width: 543,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Color(0xfff66f51),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  // textkJQ (17:492)
                                                  left: 27,
                                                  top: 16,
                                                  child: Container(
                                                    width: 432,
                                                    height: 142.5,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          // autogroup7wh6ywr (D1cBBKFPWfAqhnLNDm7wH6)
                                                          margin: EdgeInsets
                                                              .fromLTRB(0, 0, 0,
                                                                  11.5),
                                                          width:
                                                              double.infinity,
                                                          height: 93,
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                // quiziB2L (17:494)
                                                                left: 0,
                                                                top: 42,
                                                                child: Align(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 106,
                                                                    height: 51,
                                                                    child: Text(
                                                                      'Quiz I',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            40,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        height:
                                                                            1.26,
                                                                        color: Color(
                                                                            0xffffffff),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                // computerarchitecturekje (17:495)
                                                                left: 0,
                                                                top: 0,
                                                                child: Align(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 432,
                                                                    height: 51,
                                                                    child: Text(
                                                                      'Computer Architecture',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            40,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        height:
                                                                            1.26,
                                                                        color: Color(
                                                                            0xffffffff),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          // XP2 (17:493)
                                                          '4:00 - 4:30',
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            height: 1.26,
                                                            color: Color(
                                                                0xffffffff),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  // locationnJx (19:965)
                                                  left: 329,
                                                  top: 123,
                                                  child: Container(
                                                    width: 187,
                                                    height: 38,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          // locationnyA (19:967)
                                                          margin: EdgeInsets
                                                              .fromLTRB(0, 1,
                                                                  13.09, 0),
                                                          width: 16.91,
                                                          height: 25,
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/images/location.svg",
                                                            height: 15,
                                                            color: MyColors
                                                                .secondary,
                                                          ),
                                                        ),
                                                        Text(
                                                          // examhall2chJ (19:966)
                                                          'Exam Hall 2',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.26,
                                                            color: Color(
                                                                0xffffffff),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // schedule8Qk (15:371)
                        margin: EdgeInsets.fromLTRB(40, 0, 233, 0),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // timesSgL (15:343)
                              margin: EdgeInsets.fromLTRB(0, 0, 40, 0),
                              height: 2155.5,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // autogroupzsngkS8 (D1c9hrhnMqxSxCUd3VzSnG)
                                    padding: EdgeInsets.fromLTRB(0, 7.5, 0, 0),
                                    width: 110,
                                    height: double.infinity,
                                    child: Container(
                                      // timestampsGfN (15:345)
                                      padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 233),
                                      width: 104,
                                      height: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            // xYC (15:346)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 182),
                                            child: Text(
                                              '8:00',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26,
                                                color: Color(0xff272932),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // duE (15:347)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 182),
                                            child: Text(
                                              '9:00',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26,
                                                color: Color(0xff272932),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // LHr (15:348)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 78),
                                            child: Text(
                                              '10:00',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26,
                                                color: Color(0xff272932),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // Mye (15:351)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 53),
                                            child: Text(
                                              '10:30',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26,
                                                color: Color(0xfff66f51),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // c8t (15:349)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 182),
                                            child: Text(
                                              '11:00',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26,
                                                color: Color(0xff272932),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // eLU (15:350)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 182),
                                            child: Text(
                                              '12:00',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26,
                                                color: Color(0xff272932),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // 6yA (17:496)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 182),
                                            child: const Text(
                                              '13:00',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26,
                                                color: Color(0xff272932),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // 1aL (17:497)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 182),
                                            child: Text(
                                              '14:00',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26,
                                                color: Color(0xff272932),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // W1J (17:498)
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 0, 182),
                                            child: Text(
                                              '15:00',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26,
                                                color: Color(0xff272932),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            // Cui (17:499)
                                            '16:00',
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w400,
                                              height: 1.26,
                                              color: Color(0xff272932),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // arroworange194G (15:369)
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 900.5),
                                    width: 21,
                                    height: 21,
                                    child: SvgPicture.asset(
                                      "assets/images/arrow.svg",
                                      height: 15,
                                      color: MyColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // autogroupq6utqBz (D1c55pjjBABhdeZiGYQ6Ut)
                              margin: EdgeInsets.fromLTRB(0, 83, 0, 0),
                              width: 1020,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Opacity(
                                    // calendarblockvjE (15:352)
                                    opacity: 0.5,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 51),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // rectangle10cMA (15:354)
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 3),
                                            width: double.infinity,
                                            height: 1,
                                            decoration: BoxDecoration(
                                              color: Color(0x7f272932),
                                            ),
                                          ),
                                          Container(
                                            // autogroupoj4u5Ek (D1c7gLFGxMtEmfgmSkoJ4U)
                                            padding: EdgeInsets.fromLTRB(
                                                43, 36.5, 72, 40.5),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xff000000)),
                                              color: Color(0xffdbf2fd),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  // autogroupc1ja3at (D1c7ozhB4aV3MeenNpC1ja)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 76),
                                                  width: double.infinity,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        // labhQY (15:355)
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 678, 0),
                                                          child: Text(
                                                            'Lab',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 40,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.26,
                                                              color: Color(
                                                                  0xff000000),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        // locationaDS (16:442)
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 14.68, 1),
                                                        width: 22.32,
                                                        height: 33,
                                                        child: SvgPicture.asset(
                                                          "assets/images/location.svg",
                                                          height: 15,
                                                          color: MyColors
                                                              .secondary,
                                                        ),
                                                      ),
                                                      Center(
                                                        // c5201g1a (15:358)
                                                        child: Text(
                                                          'C5.201',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.26,
                                                            color: Color(
                                                                0xff000000),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  // databaseiiymN (15:357)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 17),
                                                  child: Text(
                                                    'Database II',
                                                    style: TextStyle(
                                                      fontSize: 70,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.26,
                                                      color: Color(0xff000000),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  // t7e (15:356)
                                                  '8:15 - 9:45',
                                                  style: TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.26,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // calendarblockCe8 (15:360)
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 51),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // rectangle11KTr (16:443)
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 3),
                                          width: double.infinity,
                                          height: 1,
                                          decoration: BoxDecoration(
                                            color: Color(0x7f272932),
                                          ),
                                        ),
                                        Container(
                                          // autogroupkceqEKv (D1c6sMbYuYuE8pYkmskCEQ)
                                          padding: EdgeInsets.fromLTRB(
                                              0, 36.5, 0, 40.5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff000000)),
                                            color: Color(0xffecdbfd),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // autogroupc6agrs6 (D1c72Wzx82aKQEXeKjC6ag)
                                                margin: EdgeInsets.fromLTRB(
                                                    43, 0, 72, 35.5),
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      // lecturevMA (15:364)
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 668, 0),
                                                      child: Text(
                                                        'Lecture',
                                                        style: TextStyle(
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.26,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      // locationMBa (16:441)
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 14.68, 3),
                                                      width: 22.32,
                                                      height: 33,
                                                      child: SvgPicture.asset(
                                                        "assets/images/location.svg",
                                                        height: 15,
                                                        color:
                                                            MyColors.secondary,
                                                      ),
                                                    ),
                                                    Text(
                                                      // h19det (15:367)
                                                      'H19',
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.26,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                // rectangle11ZYY (15:363)
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 46.5),
                                                width: double.infinity,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Color(0xfff66f51),
                                                ),
                                              ),
                                              Container(
                                                // networksandmedialab5Wt (15:366)
                                                margin: EdgeInsets.fromLTRB(
                                                    43, 0, 0, 7),
                                                child: Text(
                                                  'Networks and Media Lab',
                                                  style: TextStyle(
                                                    fontSize: 70,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.26,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                // NF6 (15:365)
                                                margin: EdgeInsets.fromLTRB(
                                                    43, 0, 0, 0),
                                                child: Text(
                                                  '10:00 - 11:30',
                                                  style: TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.26,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // calendarblockUZ2 (17:501)
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 617),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // rectangle10o5W (17:503)
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 3),
                                          width: double.infinity,
                                          height: 1,
                                          decoration: BoxDecoration(
                                            color: Color(0x7f272932),
                                          ),
                                        ),
                                        Container(
                                          // autogroup7vd2KJk (D1c5NUvdvwEEJDcxuN7vD2)
                                          padding: EdgeInsets.fromLTRB(
                                              43, 36.5, 72, 40.5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff000000)),
                                            color: Color(0xfffddbdb),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // autogroupeba4MFS (D1c5ZtmHooWkan8ANueba4)
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 32),
                                                width: double.infinity,
                                                height: 51,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      // tutorialPC8 (17:504)
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 602, 0),
                                                      child: Text(
                                                        'Tutorial',
                                                        style: TextStyle(
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.26,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      // locationDS4 (19:961)
                                                      height: double.infinity,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            // locationLFn (17:508)
                                                            margin: EdgeInsets
                                                                .fromLTRB(0, 0,
                                                                    14.68, 1),
                                                            width: 22.32,
                                                            height: 33,
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/images/location.svg",
                                                              height: 15,
                                                              color: MyColors
                                                                  .secondary,
                                                            ),
                                                          ),
                                                          Text(
                                                            // c52052PW (17:507)
                                                            'C5.205',
                                                            style: TextStyle(
                                                              fontSize: 40,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.26,
                                                              color: Color(
                                                                  0xff000000),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                // operatingsystems9j2 (17:506)
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 61),
                                                child: Text(
                                                  'Operating Systems',
                                                  style: TextStyle(
                                                    fontSize: 70,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.26,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                // FGG (17:505)
                                                '11:45 - 13:15',
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.26,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // calendarblockNbn (17:509)
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          // rectangle10HCx (17:511)
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 3),
                                          width: double.infinity,
                                          height: 1,
                                          decoration: BoxDecoration(
                                            color: Color(0x7f272932),
                                          ),
                                        ),
                                        Container(
                                          // autogroupsdv4PWt (D1c69i8H27HuUPudBpSdv4)
                                          padding: EdgeInsets.fromLTRB(
                                              43, 36.5, 72, 40.5),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff000000)),
                                            color: Color(0xfffdf9db),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // autogrouppvegG4t (D1c6LCpnmvovER1jWNpveG)
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 32),
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      // quizYHJ (17:512)
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 578, 0),
                                                      child: Text(
                                                        'Quiz',
                                                        style: TextStyle(
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.26,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      // locationNGL (17:516)
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 14.68, 1),
                                                      width: 22.32,
                                                      height: 33,
                                                      child: SvgPicture.asset(
                                                        "assets/images/location.svg",
                                                        height: 15,
                                                        color:
                                                            MyColors.secondary,
                                                      ),
                                                    ),
                                                    Text(
                                                      // examhall2Bja (17:515)
                                                      'Exam Hall 2',
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.26,
                                                        color:
                                                            Color(0xff000000),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                // computerarchitecturegwE (17:514)
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 61),
                                                child: Text(
                                                  'Computer Architecture',
                                                  style: TextStyle(
                                                    fontSize: 70,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.26,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                // yfS (17:513)
                                                '16:00 - 16:30',
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.26,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
