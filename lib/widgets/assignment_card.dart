import 'package:flutter/material.dart';
import '../utils/SharedPrefs.dart';
import 'grade_card.dart';
// import 'MyColors.dart';

class AssignmentCard extends StatelessWidget {
  const AssignmentCard(
      {super.key, required this.title, required this.elements});

  final String title;
  final List<Map> elements;

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
    // double percentage = score.toDouble() / scoreTotal.toDouble();
    // Color gradeColor = getScoreColor(percentage * 100);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: "Outfit",
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
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
              // const SizedBox(width: 90),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: elements.map((item) {
            return GradeCard(
              key: UniqueKey(),
              title: item['elementName'],
              score: item['score'] == 'None'
                  ? -1
                  : double.parse(item['score']),
              scoreTotal: double.parse(item['scoreTotal']),
              isElement: true,
            );
          }).toList(),
        ),
      ],
    );
  }
}
