import 'package:flutter/material.dart';
import "package:wtf_sliding_sheet/wtf_sliding_sheet.dart";
import '../main.dart';
import '../widgets/MyColors.dart';

class BuildSheet {
  BuildSheet(
      {required this.context, required this.builder, this.hasHeader = true});
  final BuildContext context;
  final Widget Function(BuildContext, SheetState) builder;
  final bool hasHeader;

  buildNotificationSheet() {
    showSlidingBottomSheet(
      context,
      builder: (context) {
        return SlidingSheetDialog(
          duration: const Duration(milliseconds: 400),
          avoidStatusBar: true,
          minHeight: MediaQuery.of(context).size.height,
          color: MyApp.isDarkMode.value
              ? MyColors.background
              : const Color.fromARGB(255, 250, 250, 254),
          cornerRadius: 20,
          snapSpec: const SnapSpec(
            snappings: [0.5, 0.75, .96],
            initialSnap: .75,
          ),
          scrollSpec: const ScrollSpec(
            overscroll: false,
          ),
          headerBuilder: (context, state) =>
              hasHeader ? _buildNotificationHeader(context) : const Text(''),
          builder: builder,
        );
      },
    );
  }

  Widget _buildNotificationHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: MyApp.isDarkMode.value
              ? MyColors.background
              : const Color.fromARGB(255, 250, 250, 254),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 175),
            height: 5,
            decoration: BoxDecoration(
              color: MyColors.secondary.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
