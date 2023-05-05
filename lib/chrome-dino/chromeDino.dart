import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gucentral/pages/home_page.dart';
import 'package:gucentral/widgets/MyColors.dart';
import 'package:gucentral/widgets/Requests.dart';
// import 'package:flutter/services.dart';
import '../utils/SharedPrefs.dart';
import 'cactus.dart';
import 'cloud.dart';
import 'dino.dart';
import 'game_object.dart';
import 'ground.dart';
import 'constants.dart';

// void main() {
//   runApp(const MyApp());
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     return const MaterialApp(
//       title: 'Flutter Dino',
//       debugShowCheckedModeBanner: false,
//       home: ChromeDino(),
//     );
//   }
// }

class ChromeDino extends StatefulWidget {
  ChromeDino({Key? key}) : super(key: key);
  @override
  _ChromeDinoState createState() => _ChromeDinoState();
}

class _ChromeDinoState extends State<ChromeDino>
    with SingleTickerProviderStateMixin {
  late Size screenSize;

  Dino dino = Dino();
  double runVelocity = initialVelocity;
  double runDistance = 0;
  int highScore = prefs.getInt(SharedPrefs.dinoHi) ?? 0;
  TextEditingController gravityController =
      TextEditingController(text: gravity.toString());
  TextEditingController accelerationController =
      TextEditingController(text: acceleration.toString());
  TextEditingController jumpVelocityController =
      TextEditingController(text: jumpVelocity.toString());
  TextEditingController runVelocityController =
      TextEditingController(text: initialVelocity.toString());
  TextEditingController dayNightOffestController =
      TextEditingController(text: dayNightOffest.toString());

  late AnimationController worldController;
  Duration lastUpdateCall = const Duration();

  List<Cactus> cacti = [Cactus(worldLocation: const Offset(200, 0))];

  List<Ground> ground = [
    Ground(worldLocation: const Offset(0, 0)),
    Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
  ];

  List<Cloud> clouds = [
    Cloud(worldLocation: const Offset(100, 20)),
    Cloud(worldLocation: const Offset(200, 10)),
    Cloud(worldLocation: const Offset(350, -10)),
  ];

  @override
  void initState() {
    super.initState();
    screenSize = Size(
        HomePage.cardSize.value.width, HomePage.cardSize.value.height * 1.25);
    print('Chrom dino size: $screenSize');

    worldController =
        AnimationController(vsync: this, duration: const Duration(days: 99));
    worldController.addListener(_update);
    // worldController.forward();
    _die();
  }

  void _die() {
    bool newHi = runDistance.toInt() > highScore;
    setState(() {
      worldController.stop();
      dino.die();
      highScore = max(highScore, runDistance.toInt());
    });

    if (newHi) {
      updateHighScore();
    }
  }

  void _newGame() {
    setState(() {
      runDistance = 0;
      runVelocity = initialVelocity;
      dino.state = DinoState.running;
      dino.dispY = 0;
      worldController.reset();
      cacti = [
        Cactus(worldLocation: const Offset(200, 0)),
        Cactus(worldLocation: const Offset(300, 0)),
        Cactus(worldLocation: const Offset(450, 0)),
      ];

      ground = [
        Ground(worldLocation: const Offset(0, 0)),
        Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
      ];

      clouds = [
        Cloud(worldLocation: const Offset(100, 20)),
        Cloud(worldLocation: const Offset(200, 10)),
        Cloud(worldLocation: const Offset(350, -15)),
        Cloud(worldLocation: const Offset(500, 10)),
        Cloud(worldLocation: const Offset(550, -10)),
      ];

      worldController.forward();
    });
  }

  _update() {
    try {
      double elapsedTimeSeconds;
      dino.update(lastUpdateCall, worldController.lastElapsedDuration);
      try {
        elapsedTimeSeconds =
            (worldController.lastElapsedDuration! - lastUpdateCall)
                    .inMilliseconds /
                1000;
      } catch (_) {
        elapsedTimeSeconds = 0;
      }

      runDistance += runVelocity * elapsedTimeSeconds;
      if (runDistance < 0) runDistance = 0;
      runVelocity += acceleration * elapsedTimeSeconds;

      Size screenSize = MediaQuery.of(context).size;

      Rect dinoRect = dino.getRect(screenSize, runDistance);
      for (Cactus cactus in cacti) {
        Rect obstacleRect = cactus.getRect(screenSize, runDistance);
        if (dinoRect.overlaps(obstacleRect.deflate(20))) {
          _die();
        }

        if (obstacleRect.right < 0) {
          setState(() {
            cacti.remove(cactus);
            cacti.add(Cactus(
                worldLocation: Offset(
                    runDistance +
                        Random().nextInt(100) +
                        MediaQuery.of(context).size.width / worlToPixelRatio,
                    0)));
          });
        }
      }

      for (Ground groundlet in ground) {
        if (groundlet.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            ground.remove(groundlet);
            ground.add(
              Ground(
                worldLocation: Offset(
                  ground.last.worldLocation.dx + groundSprite.imageWidth / 10,
                  0,
                ),
              ),
            );
          });
        }
      }

      for (Cloud cloud in clouds) {
        if (cloud.getRect(screenSize, runDistance).right < 0) {
          setState(() {
            clouds.remove(cloud);
            clouds.add(
              Cloud(
                worldLocation: Offset(
                  clouds.last.worldLocation.dx +
                      Random().nextInt(200) +
                      MediaQuery.of(context).size.width / worlToPixelRatio,
                  Random().nextInt(50) - 25.0,
                ),
              ),
            );
          });
        }
      }

      lastUpdateCall = worldController.lastElapsedDuration!;
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    gravityController.dispose();
    accelerationController.dispose();
    jumpVelocityController.dispose();
    runVelocityController.dispose();
    dayNightOffestController.dispose();
    _die();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (GameObject object in [...clouds, ...ground, ...cacti, dino]) {
      children.add(
        AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              // bottom: objectRect.bottom,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          },
        ),
      );
    }

    return ValueListenableBuilder<Size>(
        valueListenable: HomePage.cardSize,
        builder: (context, cardS, child) {
          screenSize = Size(HomePage.cardSize.value.width,
              HomePage.cardSize.value.height * 1.25);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 3000),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                15.0,
              ),
              // border: Border.all(color: MyColors.secondary),
              color: (runDistance ~/ dayNightOffest) % 2 == 0
                  ? Colors.white
                  : Colors.black,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) {
                if (dino.state != DinoState.dead) {
                  dino.jump();
                }
                if (dino.state == DinoState.dead) {
                  _newGame();
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ...children,
                  AnimatedBuilder(
                    animation: worldController,
                    builder: (context, _) {
                      return Positioned(
                        right: 35,
                        top: 10,
                        child: Text(
                          runDistance.toInt().toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (runDistance ~/ dayNightOffest) % 2 == 0
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: worldController,
                    builder: (context, _) {
                      return Positioned(
                        left: 35,
                        top: 10,
                        child: Text(
                          'HIGH SCORE: $highScore',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (runDistance ~/ dayNightOffest) % 2 == 0
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    left: -5,
                    top: -5,
                    child: IconButton(
                      onPressed: () {
                        showLeaderboard();
                      },
                      icon: const Icon(Icons.leaderboard, size: 20),
                    ),
                  ),
                  Positioned(
                    right: -5,
                    top: -5,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 3),
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        color: (runDistance ~/ dayNightOffest) % 2 == 0
                            ? Colors.black
                            : Colors.white,
                        onPressed: () {
                          _die();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Change Physics"),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 280,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Gravity:"),
                                          SizedBox(
                                            height: 25,
                                            width: 75,
                                            child: TextField(
                                              controller: gravityController,
                                              key: UniqueKey(),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 280,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Acceleration:"),
                                          SizedBox(
                                            child: TextField(
                                              controller:
                                                  accelerationController,
                                              key: UniqueKey(),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            height: 25,
                                            width: 75,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 280,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Initial Velocity:"),
                                          SizedBox(
                                            child: TextField(
                                              controller: runVelocityController,
                                              key: UniqueKey(),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            height: 25,
                                            width: 75,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 280,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Jump Velocity:"),
                                          SizedBox(
                                            child: TextField(
                                              controller:
                                                  jumpVelocityController,
                                              key: UniqueKey(),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            height: 25,
                                            width: 75,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 280,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Day-Night Offset:"),
                                          SizedBox(
                                            child: TextField(
                                              controller:
                                                  dayNightOffestController,
                                              key: UniqueKey(),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            height: 25,
                                            width: 75,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  //Submit Leaderboard Score

                                  TextButton(
                                    onPressed: () {
                                      gravity =
                                          int.parse(gravityController.text);
                                      acceleration = double.parse(
                                          accelerationController.text);
                                      initialVelocity = double.parse(
                                          runVelocityController.text);
                                      jumpVelocity = double.parse(
                                          jumpVelocityController.text);
                                      dayNightOffest = int.parse(
                                          dayNightOffestController.text);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Done",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 10,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       _die();
                  //     },
                  //     child: const Text(
                  //       "Force Kill Dino",
                  //       style: TextStyle(color: Colors.red),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        });
  }

  void updateHighScore() async {
    prefs.setInt(SharedPrefs.dinoHi, highScore);
    // Use firestore to submit high score to 'leaderboards' collection, 'chrome_dino' document and then get the leaderboard and print it
    final docDino = FirebaseFirestore.instance
        .collection('chrome_dino')
        .doc(prefs.getString('username'));

    final snapshot = await docDino.get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      if (data['score'] < highScore) {
        await docDino.update({
          'score': highScore,
          'major': buildMajor(),
        });
      }
      return;
    }

    final json = {
      'name': prefs.getString('name'),
      'score': highScore,
      'major': buildMajor(),
    };

    await docDino.set(json);
  }

  showLeaderboard() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text('Leaderboard', textAlign: TextAlign.center),
            contentPadding: const EdgeInsets.all(15),
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            content: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chrome_dino')
                  .orderBy('score', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: AnimationLimiter(
                      key: ValueKey("$documents"),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final doc = documents[index];
                          final data = doc.data() as Map<String, dynamic>;
                          return AnimationConfiguration.staggeredList(
                            delay: const Duration(milliseconds: 50),
                            position: index,
                            duration: const Duration(milliseconds: 200),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  // convert it from a listtile to a container whose child is a row containing the 3 components

                                  child: Container(
                                    height: 70,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey[100]),
                                    child: Row(children: [
                                      Expanded(
                                        flex: 2,
                                        child: index == 0
                                            ? const Icon(Icons.emoji_events,
                                                size: 30, color: Colors.amber)
                                            : index == 1
                                                ? const Icon(Icons.emoji_events,
                                                    size: 30,
                                                    color: Colors.grey)
                                                : index == 2
                                                    ? const Icon(
                                                        Icons.emoji_events,
                                                        size: 30,
                                                        color: Color.fromARGB(
                                                            255, 166, 74, 40))
                                                    : Text(
                                                        getRanking(index + 1),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          flex: 10,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['name'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    height: 1.1, fontSize: 15),
                                              ),
                                              data['major'] != null
                                                  ? Text(data['major'],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontWeight:
                                                              FontWeight.w300))
                                                  : Container(),
                                            ],
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        flex: 3,
                                        child: AutoSizeText(
                                          '${data['score']}',
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          );
        });
  }

  getRanking(int num) {
    if (num % 100 >= 11 && num % 100 <= 13) {
      return "${num}th";
    }
    switch (num % 10) {
      case 1:
        return "${num}st";
      case 2:
        return "${num}nd";
      case 3:
        return "${num}rd";
      default:
        return "${num}th";
    }
  }

  String buildMajor() {
    String major = prefs.getString('major') ?? "";
    String id = prefs.getString('id')!;
    String batch = id.substring(0, id.indexOf('-') + 1);
    return '$batch$major';
  }
}
