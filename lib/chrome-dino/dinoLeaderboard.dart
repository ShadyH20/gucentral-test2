import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gucentral/chrome-dino/cactus.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../utils/SharedPrefs.dart';

class DinoLeaderboard extends StatefulWidget {
  const DinoLeaderboard({super.key});

  @override
  State<DinoLeaderboard> createState() => _DinoLeaderboardState();
}

class _DinoLeaderboardState extends State<DinoLeaderboard>
    with SingleTickerProviderStateMixin {
  late final myStream = FirebaseFirestore.instance
      .collection('chrome_dino')
      .orderBy('score', descending: true)
      .snapshots();

  final double _cardHeight = 80.0;

  int _currentPlayerIndex = -1;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late ScrollController _scrollController;

  bool firstTime = true;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    super.initState();
    // var db = FirebaseFirestore.instance;
    // var batch = db.batch();

    // var array = List.filled(
    //     40, {"name": "Shady Hanii Emill", "score": 798, "major": "CSEN"});

    // for (var doc in array) {
    //   var docRef =
    //       db.collection("col").doc(); //automatically generate unique id
    //   batch.set(docRef, doc);
    // }

    // batch.commit();
  }

  @override
  dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }

  bool showBottomCard = false;
  bool showTopCard = false;

  void _onScroll() {
    if (_currentPlayerIndex == -1) return;

    double offset = _scrollController.offset;

    var willShowBottomCard = offset <
        _cardHeight * _currentPlayerIndex - MediaQuery.of(context).size.height;
    if (willShowBottomCard != showBottomCard) {
      setState(() {
        showBottomCard = willShowBottomCard;
      });
    }

    var willShowTopCard = offset > (_cardHeight * _currentPlayerIndex);
    if (willShowTopCard != showTopCard) {
      setState(() {
        showTopCard = willShowTopCard;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyApp.isDarkMode.value
            ? MyColors.background
            : const Color.fromARGB(255, 230, 230, 230),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.background,
          title: const Text('Leaderboard'),
          foregroundColor: MyColors.secondary,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: StreamBuilder<QuerySnapshot>(
              stream: myStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // check if first time
                  if (firstTime) {
                    if (_scrollController.hasClients) {
                      firstTime = false;
                      _scrollController.animateTo(0,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut);
                    }
                  }

                  final List<DocumentSnapshot> documents = snapshot.data!.docs;

                  findCurrentPlayer(documents);

                  return Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final doc = documents[index];
                          final data = doc.data() as Map<String, dynamic>;
                          if (index == _currentPlayerIndex) {
                            //// CURRENT PLAYER CARD ////
                            return currentPlayerCard(data, index, false);
                          }
                          //// ALL PLAYER CARDS ////
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            color: MyApp.isDarkMode.value
                                ? const Color.fromARGB(255, 28, 28, 30)
                                : Colors.white,
                            child: PlayerCard(data, index, MyColors.secondary),
                          );
                        },
                      ),

                      //// PINNED TOP CURRENT PLAYER CARD ////
                      if (showTopCard)
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          top: 0,
                          height: _cardHeight - 10,
                          child: Container(
                            color: MyApp.isDarkMode.value
                                ? Colors.black
                                : const Color.fromARGB(255, 230, 230, 230),
                            child: currentPlayerCard(
                                documents[_currentPlayerIndex].data()
                                    as Map<String, dynamic>,
                                _currentPlayerIndex,
                                true,
                                isTop: true),
                          ),
                        ),

                      //// PINNED BOTTOM CURRENT PLAYER CARD ////
                      if (showBottomCard)
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          bottom: 0,
                          height: _cardHeight - 10,
                          child: Container(
                            color: MyApp.isDarkMode.value
                                ? Colors.black
                                : const Color.fromARGB(255, 230, 230, 230),
                            child: currentPlayerCard(
                                documents[_currentPlayerIndex].data()
                                    as Map<String, dynamic>,
                                _currentPlayerIndex,
                                true,
                                isTop: false),
                          ),
                        ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }

  Card currentPlayerCard(Map<String, dynamic> data, int index, bool pinned,
      {bool isTop = false}) {
    return Card(
      elevation: pinned ? 8 : 20,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: MyApp.isDarkMode.value ? MyColors.secondary : MyColors.primary,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
          left: 7, right: 7, bottom: pinned ? 0 : 5, top: pinned ? 0 : 5),
      color: MyApp.isDarkMode.value ? MyColors.surface : Colors.white,
      child: Center(
          child: PlayerCard(data, index, MyColors.surface, isCurr: true)),
    );
  }

  void findCurrentPlayer(List<DocumentSnapshot<Object?>> documents) {
    for (int i = 0; i < documents.length; i++) {
      final doc = documents[i];
      String id = doc.id;
      if (id == prefs.getString(SharedPrefs.username)) {
        _currentPlayerIndex = i;
        break;
      }
    }
  }
}

class PlayerCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;
  final Color background;

  final bool isCurr;

  const PlayerCard(this.data, this.index, this.background,
      {Key? key, this.isCurr = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        horizontalTitleGap: 10,
        title: AutoSizeText(
          data['name'].split(' ').sublist(0, 3).join(' '),
          maxLines: 1,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
        ),
        subtitle: Text('${data['major'].replaceAll('"', '')}',
            style:
                TextStyle(fontSize: 14, height: 1.2, color: MyColors.tertiary)),
        leading: index < 3
            ? top3Icon(index)
            : Container(
                alignment: Alignment.center,
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                  color: isCurr && MyApp.isDarkMode.value
                      ? const Color.fromARGB(255, 48, 50, 61)
                      : background.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
        trailing: Container(
          width: 70,
          alignment: Alignment.centerRight,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    // text: NumberFormat.compact().format(data['score']),
                    text: NumberFormat.decimalPattern().format(data['score']),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: MyColors.secondary,
                    ),
                  ),
                  TextSpan(
                    text: ' pts',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  top3Icon(int index) {
    return Stack(alignment: Alignment.center, children: [
      Text(
        ['🥇', '🥈', '🥉'][index],
        style: const TextStyle(fontSize: 39),
      ),
    ]);
  }
}

class CurrentPlayerCard extends StatelessWidget {
  const CurrentPlayerCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.all(0),
      color: Colors.black,
      child: ListTile(
        title: Text('Shady Hani'),
        subtitle: Text('Score: 1768'),
      ),
    );
  }
}
