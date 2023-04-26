import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/MyColors.dart';

class SemesterRange extends StatefulWidget {
  const SemesterRange({super.key});

  @override
  State<SemesterRange> createState() => _SemesterRangeState();
}

class _SemesterRangeState extends State<SemesterRange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: MyColors.background,
        //     statusBarIconBrightness: Brightness.dark,
        //     statusBarBrightness: Brightness.dark),
        backgroundColor: MyColors.background,
        foregroundColor: MyColors.secondary,
        title: const Text(
          "Semester Start & End",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
