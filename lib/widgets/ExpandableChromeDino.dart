import 'dart:math';

import 'package:flutter/material.dart';

import '../chrome-dino/chromeDino.dart';
import '../pages/home_page.dart';
import '../utils/MeasureSize.dart';
import '../utils/SharedPrefs.dart';

class ExpandableChromeDino extends StatefulWidget {
  const ExpandableChromeDino({super.key});

  @override
  State<ExpandableChromeDino> createState() => _ExpandableChromeDinoState();
}

// extension to convert int to Duration
extension IntToDuration on int {
  Duration get ms => Duration(milliseconds: this);
}

class _ExpandableChromeDinoState extends State<ExpandableChromeDino>
    with SingleTickerProviderStateMixin {
  late final _menuAC = AnimationController(
      vsync: this, duration: 700.ms, reverseDuration: 300.ms);
  late final isFilterOpen = ValueNotifier(false)
    ..addListener(_handleFilterOpenChanged);

  late final filterColor =
      ColorTween(begin: Colors.transparent, end: Colors.white).animate(
    CurvedAnimation(
      parent: _menuAC,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeOutBack,
    ),
  );
  late final filterBorderRadius =
      Tween<double>(begin: 12, end: 0).animate(_menuAC);

  late final curvedAnimation = CurvedAnimation(
    parent: _menuAC,
    curve: Curves.easeInOut,
    reverseCurve: Curves.easeInOut,
  );

  late final dinoGame = ChromeDino(
    closeGame: closeGame,
  );

  void _handleFilterOpenChanged() {
    // print(isFilterOpen.value);
    if (isFilterOpen.value) {
      _menuAC.forward();
    } else {
      _menuAC.reverse();
    }
  }

  @override
  void dispose() {
    _menuAC.dispose();
    super.dispose();
  }

  double iconSize = 65.0;
  @override
  Widget build(BuildContext context) {
    // double pageWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        border: !isFilterOpen.value
            ? null
            : Border.symmetric(
                horizontal: BorderSide(
                  color: MyColors.secondary,
                  width: 1.5,
                ),
              ),
      ),
      child: AnimatedSize(
        curve: Curves.easeInOut,
        duration: 700.ms,
        reverseDuration: 300.ms,
        child: SizedBox(
          width: _size,
          height: _size,
          child: _size != 65
              ? dinoGame
              : Card(
                  clipBehavior: Clip.hardEdge,
                  color: Colors.transparent,
                  elevation: 7,
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        // isFilterOpen.value = !isFilterOpen.value;
                        _size = _size == iconSize ? null : iconSize;
                      });
                    },
                    child: Image.asset(
                      'assets/images/dino/dino_icon.png',
                    ),
                  )),
        ),
      ),
    );
  }

  late double? _size = iconSize;
  void closeGame() {
    // isFilterOpen.value = !isFilterOpen.value;
    setState(() {
      _size = _size == iconSize ? null : iconSize;
    });
  }
}
