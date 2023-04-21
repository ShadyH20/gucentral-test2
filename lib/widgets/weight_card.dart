import 'package:flutter/material.dart';
import 'MyColors.dart';

class WeightCard extends StatelessWidget {
  const WeightCard(
      {super.key,
      required this.text,
      required this.weight,
      this.best = const []});

  final String text;
  final String weight;
  final List<String> best;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Text(
            '$text${best.length == 2 ? ' | Best ${best[0]} from ${best[1]}' : ''}',
            style: const TextStyle(
              fontFamily: "Outfit",
              fontWeight: FontWeight.w700,
              fontSize: 15,
              decoration: TextDecoration.none,
              color: MyColors.secondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              color: const Color.fromARGB(30, 0, 0, 0),
              height: 1,
              // width: 30,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$weight%',
            style: const TextStyle(
              fontFamily: "Outfit",
              fontWeight: FontWeight.w700,
              fontSize: 15,
              decoration: TextDecoration.none,
              color: MyColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
