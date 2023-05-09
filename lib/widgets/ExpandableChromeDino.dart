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
      vsync: this, duration: 1000.ms, reverseDuration: 300.ms);
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

  @override
  Widget build(BuildContext context) {
    double iconSize = 70.0;
    return LayoutBuilder(
      builder: (context, cons) => SizedBox(
        width: cons.maxWidth,
        height: cons.maxHeight,
        child: ValueListenableBuilder<Size>(
            valueListenable: HomePage.cardSize,
            builder: (context, size, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                      animation: _menuAC,
                      builder: (context, child) {
                        return Positioned(
                          top: Tween(
                                  begin:
                                      (HomePage.cardDy - kToolbarHeight - 24) +
                                          HomePage.cardSize.value.height / 2 -
                                          iconSize / 2,
                                  end:
                                      HomePage.cardDy - kToolbarHeight - 24 - 5)
                              .evaluate(_menuAC),
                          height: Tween(
                                  begin: iconSize,
                                  end: HomePage.cardSize.value.height + 10)
                              .evaluate(_menuAC),
                          child: Card(
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Tween<double>(begin: 14, end: 0)
                                      .evaluate(_menuAC)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                // const Radius.circular(12.0),
                                topLeft: Radius.circular(
                                    Tween<double>(begin: 14, end: 0)
                                        .evaluate(_menuAC)),
                                topRight: Radius.circular(
                                    Tween<double>(begin: 14, end: 0)
                                        .evaluate(_menuAC)),
                                bottomLeft: Radius.circular(
                                    Tween<double>(begin: 14, end: 0)
                                        .evaluate(_menuAC)),
                                bottomRight: Radius.circular(
                                    Tween<double>(begin: 14, end: 0)
                                        .evaluate(_menuAC)),
                              ),
                              child: Container(
                                width: Tween(
                                        begin: iconSize,
                                        end: MediaQuery.of(context).size.width)
                                    .evaluate(curvedAnimation),
                                height: Tween(
                                        begin: iconSize,
                                        end: HomePage.cardSize.value.height)
                                    .evaluate(curvedAnimation),
                                decoration: BoxDecoration(
                                  // color: filterColor.value,
                                  color: Colors.white,
                                ),
                                child: child,
                              ),
                            ),
                          ),
                        );
                      },
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isFilterOpen.value = !isFilterOpen.value;
                            // myChild = myChild == dinoIcon ? dinoGame : dinoIcon;
                          });
                        },
                        child: Center(
                          child: isFilterOpen.value
                              ? dinoGame
                              : Image.asset(
                                  'assets/images/dino/dino_icon.png',
                                ),
                        ),
                      )),
                  isFilterOpen.value
                      ? Container()
                      : Positioned(
                          top: (HomePage.cardDy - kToolbarHeight - 24) +
                              HomePage.cardSize.value.height / 2 +
                              iconSize / 2 +
                              5,
                          child: Text(
                            'Chrome Dino',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: MyColors.secondary,
                              fontSize: 17.0,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ],
              );
            }),
      ),
    );
  }

  void closeGame() {
    isFilterOpen.value = !isFilterOpen.value;
    setState(() {
      // myChild = dinoIcon;
    });
  }
}
