import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../main.dart';
import '../utils/SharedPrefs.dart';
// import 'MyColors.dart';

class GradeCard extends StatelessWidget {
  const GradeCard({
    super.key,
    required this.title,
    required this.score,
    required this.scoreTotal,
    this.isElement = false,
  });

  final String title;
  final double score;
  final double scoreTotal;
  final bool isElement;

  Color getScoreColor(double percentage) {
    if (percentage > 80) {
      return const Color(0xFF38c37d);
    } else if (percentage > 60) {
      return const Color(0xFF75d4d0);
    } else if (percentage > 40) {
      return const Color(0xFFffcb00);
    } else if (percentage > 20) {
      return const Color(0xFFffaf00);
    } else {
      return const Color(0xFFff5a64);
    }
  }

  String getScore(double score) {
    double test = double.tryParse(score.toStringAsFixed(1))! -
        double.tryParse(score.toStringAsFixed(0))!;

    if (test == 0) return score.toStringAsFixed(0);
    return score.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    double percentage = score.toDouble() / scoreTotal.toDouble();
    Color gradeColor = getScoreColor(percentage * 100);
    return Container(
      padding: !isElement
          ? const EdgeInsets.symmetric(vertical: 7, horizontal: 50)
          : const EdgeInsets.only(top: 7, bottom: 7, right: 50, left: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              // fontFamily: "Outfit",
              fontWeight: !isElement ? FontWeight.w700 : FontWeight.w200,
              fontSize: !isElement ? 16 : 15,
              color: MyColors.secondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              color: MyColors.secondary.withOpacity(0.3),
              height: 1,
              // width: 30,
            ),
          ),
          const SizedBox(width: 10),
          CircularPercentIndicator(
            radius: 25,
            animation: true,
            animationDuration: 800,
            animateFromLastPercent: true,
            percent: percentage,
            progressColor: gradeColor,
            backgroundColor: MyApp.isDarkMode.value
                ? const Color.fromARGB(255, 52, 52, 52)
                : const Color(0xFFdedede),
            circularStrokeCap: CircularStrokeCap.round,
            center: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: getScore(score),
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        // height: 19,
                        color: gradeColor,
                      ),
                    ),
                    TextSpan(
                      text: ' / ${scoreTotal.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                        color: gradeColor,
                      ),
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
}
