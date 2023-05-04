import 'dart:collection';

import 'package:flutter/material.dart';
import 'weight.dart';

class WeightData extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Weight> _allWeights = [
    Weight(text: 'Midterm', weight: '35'),
    Weight(text: 'Assignments', weight: '15', best: ['3', '4']),
  ];

  bool isDismissable = true;

  void setIsDismissable(bool value) {
    isDismissable = value;
    notifyListeners();
  }

  void addToWeights(Weight newWeight) {
    _allWeights.add(newWeight);
    notifyListeners();
  }

  void removeWeight(Weight weightToRemove) {
    _allWeights.remove(weightToRemove);
    notifyListeners();
  }

  updateWeightPosition(int oldIndex, int newIndex) {
    final item = _allWeights.removeAt(oldIndex);
    if (newIndex > oldIndex) newIndex -= 1;
    _allWeights.insert(newIndex, item);
    // print('\n\nOLD INDEX: $oldIndex\nNEW INDEX: $newIndex\n\n');
    notifyListeners();
  }

  UnmodifiableListView<Weight> get allWeights {
    return UnmodifiableListView(_allWeights);
  }
}
