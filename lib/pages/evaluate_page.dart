import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gucentral/pages/evaluate/evaluate_courses.dart';
import 'package:gucentral/widgets/Requests.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

import '../widgets/MenuWidget.dart';
import '../widgets/MyColors.dart';

class EvaluatePage extends StatefulWidget {
  const EvaluatePage({super.key});

  @override
  State<EvaluatePage> createState() => _EvaluatePageState();
}

class _EvaluatePageState extends State<EvaluatePage> {
  int pageIndex = 0;

  var pages = [];

  @override
  void initState() {
    // pages = [EvaluateCourses()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: evaluateAppBar(),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          color: const Color.fromARGB(255, 250, 250, 250),
          child: buildBottomNavBar(),
        ),
        body: SlideIndexedStack(
          // endSlideOffset: const Offset(0.0, 0),
          beginSlideOffset: Offset(pageIndex == 0 ? 1.0 : -1.0, 0.0),
          // curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 250),
          // LazyLoadIndexedStack(
          index: pageIndex,
          children: const [
            EvaluateCourses(),
            Center(child: Text("Evaluate Academics"))
          ],
        ));
  }

  BottomNavigationBar buildBottomNavBar() {
    return BottomNavigationBar(
      elevation: 0,

      // type: BottomNavigationBarType.shifting,
      unselectedItemColor: MyColors.secondary,
      showUnselectedLabels: true,
      currentIndex: pageIndex,
      onTap: (value) {
        setState(() {
          pageIndex = value;
        });
      },
      iconSize: 40,
      selectedIconTheme: const IconThemeData(size: 40),
      unselectedFontSize: 22,
      selectedFontSize: 22,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_outlined), label: "Courses"),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded), label: "Academics"),
      ],
    );
  }

  evaluateAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: MyColors.primary,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark),
      elevation: 0,
      backgroundColor: MyColors.background,
      centerTitle: true,
      leadingWidth: 60.0,
      leading: const MenuWidget(),
      title: const Text(
        "Evaluate",
        // textScaleFactor: 0.95,
        style: TextStyle(color: MyColors.primary),
      ),
      actions: [
        IconButton(
          splashRadius: 15,
          // padding: EdgeInsets.symmetric(horizontal: 20.0),
          icon: SvgPicture.asset(
            "assets/images/refresh.svg",
            height: 24,
            color: MyColors.secondary,
          ),
          onPressed: () {
            // initCoursesToEval();
          },
        ),
        Container(
          width: 10,
        )
      ],
    );
  }
}
