import 'package:flutter/material.dart';
import 'package:gucentral/utils/weight_data.dart';
import 'package:provider/provider.dart';
import "package:wtf_sliding_sheet/wtf_sliding_sheet.dart";
import '../main.dart';
import 'SharedPrefs.dart';
// import '../widgets/MyColors.dart';

class BuildSheet {
  BuildSheet({
    required this.context,
    required this.builder,
    this.hasHeader = true,
    this.initialSnap = .75,
    this.snappings = const [0.5, 0.75, .85],
  });

  final BuildContext context;
  final Widget Function(BuildContext, SheetState) builder;
  final bool hasHeader;
  final double initialSnap;
  final List<double> snappings;

  buildNotificationSheet() {
    showSlidingBottomSheet(
      context,
      builder: (context) {
        return SlidingSheetDialog(
          isDismissable:
              Provider.of<WeightData>(context, listen: false).isDismissable,
          duration: const Duration(milliseconds: 400),
          avoidStatusBar: true,
          // minHeight: MediaQuery.of(context).size.height,
          color: MyApp.isDarkMode.value
              ? MyColors.background
              : const Color.fromARGB(255, 250, 250, 254),
          cornerRadius: 20,
          snapSpec: SnapSpec(
            snappings: snappings,
            initialSnap: initialSnap,
          ),
          scrollSpec: const ScrollSpec(
            overscroll: false,
            physics: NeverScrollableScrollPhysics(),
          ),
          headerBuilder: (context, state) =>
              hasHeader ? _buildNotificationHeader(context) : const Text(''),
          builder: builder,
        );
      },
    );
  }

  Widget _buildNotificationHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width,
      // height: 50,
      decoration: BoxDecoration(
        color: MyApp.isDarkMode.value
            ? MyColors.background
            : const Color.fromARGB(255, 255, 250, 254),
        // color: MyColors.secondary.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 175),
        height: 5,
        decoration: BoxDecoration(
          color: MyColors.secondary.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
