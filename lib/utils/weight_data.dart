import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'weight.dart';
import 'SharedPrefs.dart';

class WeightData extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<Weight> _allWeights = [
    Weight(text: 'Midterm', weight: '35'),
    Weight(text: 'Assignments', weight: '15', best: ['3', '4']),
  ];

  bool isDismissable = true;
  String? courseCode;

  void setIsDismissable(bool value) {
    isDismissable = value;
    notifyListeners();
  }

  void changeAllWeights(String courseCode) {
    dynamic weights = prefs.getString('weights:$courseCode');
    this.courseCode = courseCode;

    if (weights == null) {
      _allWeights = [];
    } else {
      print('JSONNNNN: ${jsonDecode(weights)}');
      _allWeights = jsonDecode(weights).map<Weight>((item) {
        return Weight.fromJson(item);
      }).toList();
    }

    print('COURSE CODE: $courseCode');
    print('WEIGHTS: $weights');
    print('ALL-WEIGHTS: $_allWeights');
    notifyListeners();
  }

  void addToWeights(Weight newWeight) {
    _allWeights.add(newWeight);
    prefs.setString(
        '${SharedPrefs.weights}$courseCode', jsonEncode(_allWeights));
    notifyListeners();
  }

  void removeWeight(Weight weightToRemove) {
    _allWeights.remove(weightToRemove);
    prefs.setString(
        '${SharedPrefs.weights}$courseCode', jsonEncode(_allWeights));
    notifyListeners();
  }

  updateWeightPosition(int oldIndex, int newIndex) {
    final item = _allWeights.removeAt(oldIndex);
    if (newIndex > oldIndex) newIndex -= 1;
    _allWeights.insert(newIndex, item);
    // print('\n\nOLD INDEX: $oldIndex\nNEW INDEX: $newIndex\n\n');
    prefs.setString('weights:$courseCode', jsonEncode(_allWeights));
    notifyListeners();
  }

  UnmodifiableListView<Weight> get allWeights {
    return UnmodifiableListView(_allWeights);
  }
}
