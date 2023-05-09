import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gucentral/chrome-dino/cactus.dart';
import 'package:intl/intl.dart';
import '../utils/SharedPrefs.dart';

class DinoLeaderboard extends StatefulWidget {
  const DinoLeaderboard({super.key});

  @override
  State<DinoLeaderboard> createState() => _DinoLeaderboardState();
}

class _DinoLeaderboardState extends State<DinoLeaderboard>
    with SingleTickerProviderStateMixin {
  // The height of each card in the leaderboard
  final double _cardHeight = 80.0;

  // The number of cards in the leaderboard
  final int _numCards = 50;

  // The index of the current player's card
  int _currentPlayerIndex = -1;

  // The animation controller for the current player's card
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  // The scroll controller for the list view
  final ScrollController _scrollController = ScrollController();

  // The position of the current player's card
  // late double _cardPosition = _cardHeight * _currentPlayerIndex;

  // The number of visible items in the list view
  int visibleItemCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;
    visibleItemCount = (viewportHeight / _cardHeight).ceil();
    // final firstVisibleIndex = (scrollOffset / _cardHeight).floor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.background,
        appBar: AppBar(
          title: const Text('Leaderboard'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chrome_dino')
                .orderBy('score', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                findCurrentPlayer(documents);

                return Stack(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      controller: _scrollController,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final doc = documents[index];
                        final data = doc.data() as Map<String, dynamic>;
                        if (index == _currentPlayerIndex) {
                          return Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: MyColors.secondary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(3),
                            color: MyColors.surface,
                            child: PlayerCard(data, index, MyColors.surface),
                          ); // don't render the current player's card here
                        }
                        return Card(
                          margin: const EdgeInsets.all(3),
                          color: MyColors.secondary.withOpacity(0.1),
                          child: PlayerCard(data, index, MyColors.secondary),
                        );
                      },
                    )),
                    // The Shady Hani Card only appears when the current player's card is not visible
                    // only when i have scrolled past the current player's card

                    if (_scrollController.hasClients &&
                        _currentPlayerIndex != -1 &&
                        _scrollController.offset >
                            _cardHeight * _currentPlayerIndex)
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        top: 0,
                        height: _cardHeight,
                        child: Card(
                          margin: const EdgeInsets.all(1),
                          color: MyColors.surface.withOpacity(0.7),
                          child: Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: MyColors.secondary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(3),
                            color: MyColors.surface,
                            child: PlayerCard(
                                documents[_currentPlayerIndex].data()
                                    as Map<String, dynamic>,
                                _currentPlayerIndex,
                                MyColors.surface),
                          ),
                        ),
                      ),

                    // if the shady hani card is yet to come
                    // - height of appbar
                    if (_scrollController.hasClients &&
                        _currentPlayerIndex != -1 &&
                        _scrollController.offset <
                            _cardHeight * _currentPlayerIndex -
                                MediaQuery.of(context).size.height +
                                2 * _cardHeight)
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 0,
                        height: _cardHeight,
                        child: const CurrentPlayerCard(),
                      ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
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

  const PlayerCard(this.data, this.index, this.background, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        horizontalTitleGap: 10,
        title: AutoSizeText(
          data['name'].split(' ').sublist(0, 3).join(' '),
          maxLines: 1,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Text(data['major'],
            style:
                TextStyle(fontSize: 15, height: 1.2, color: MyColors.tertiary)),
        leading: Container(
          alignment: Alignment.center,
          width: 50,
          height: 40,
          decoration: BoxDecoration(
            color: background.withOpacity(0.04),
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
                    text: NumberFormat.compact().format(data['score']),
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
}

class CurrentPlayerCard extends StatelessWidget {
  const CurrentPlayerCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      color: Colors.black,
      child: ListTile(
        title: Text('Shady Hani'),
        subtitle: Text('Score: 1768'),
      ),
    );
  }
}
