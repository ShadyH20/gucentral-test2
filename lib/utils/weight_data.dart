import 'dart:collection';

import 'package:flutter/material.dart';
import 'weight.dart';

class WeightData extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Weight> _allWeights = [
    Weight(text: 'Midterm', weight: '35'),
    Weight(text: 'Assignments', weight: '15', best: ['3', '4']),
  ];

  void addToWeights(Weight newWeight) {
    _allWeights.add(newWeight);
    notifyListeners();
  }

  void removeWeight(Weight weightToRemove) {
    _allWeights.remove(weightToRemove);
    notifyListeners();
  }

  UnmodifiableListView<Weight> get allWeights {
    return UnmodifiableListView(_allWeights);
  }
}
