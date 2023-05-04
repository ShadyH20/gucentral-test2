import 'package:flutter/material.dart';

class WeightData extends ChangeNotifier {
  List<Map> allWeights = [
    {
      'text': 'Midterm',
      'weight': '35',
      'best': [],
    },
    {
      'text': 'Assignments',
      'weight': '15',
      'best': ['3', '4'],
    },
  ];

  void addToWeights(Map newWeight) {
    allWeights.add(newWeight);
    notifyListeners();
  }
}
