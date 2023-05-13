import 'dart:math';

import 'package:flutter/widgets.dart';

import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

double scale = 0.45;

List<Sprite> cacti = [
  Sprite()
    ..imagePath = "assets/images/cacti/cacti_group.png"
    ..imageWidth = (104 * scale).toInt()
    ..imageHeight = (100 * scale).toInt(),
  Sprite()
    ..imagePath = "assets/images/cacti/cacti_large_1.png"
    ..imageWidth = (50 * scale).toInt()
    ..imageHeight = (100 * scale).toInt(),
  Sprite()
    ..imagePath = "assets/images/cacti/cacti_large_2.png"
    ..imageWidth = (98 * scale).toInt()
    ..imageHeight = (100 * scale).toInt(),
  Sprite()
    ..imagePath = "assets/images/cacti/cacti_small_1.png"
    ..imageWidth = (34 * scale).toInt()
    ..imageHeight = (70 * scale).toInt(),
  Sprite()
    ..imagePath = "assets/images/cacti/cacti_small_2.png"
    ..imageWidth = (68 * scale).toInt()
    ..imageHeight = (70 * scale).toInt(),
  Sprite()
    ..imagePath = "assets/images/cacti/cacti_small_3.png"
    ..imageWidth = (107 * scale).toInt()
    ..imageHeight = (107 * scale).toInt()
  // ..imageHeight = (70 * scale).toInt(),
];

class Cactus extends GameObject {
  final Sprite sprite;
  final Offset worldLocation;

  Cactus({required this.worldLocation})
      : sprite = cacti[Random().nextInt(cacti.length)];

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worlToPixelRatio,
      screenSize.height / 1.75 - sprite.imageHeight,
      sprite.imageWidth.toDouble(),
      sprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(sprite.imagePath);
  }
}
