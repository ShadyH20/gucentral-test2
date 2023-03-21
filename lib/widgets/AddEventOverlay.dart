import 'dart:ui';

import 'package:flutter/material.dart';

import 'MyColors.dart';
// import 'package:flutter_overlay_library/flutter_overlay_library.dart';

class AddEventOverlay extends StatefulWidget {
  @override
  _AddEventOverlayState createState() => _AddEventOverlayState();
}

class _AddEventOverlayState extends State<AddEventOverlay> {
  bool _showOverlay = false;
  late OverlayEntry overlayEntry;

  void _showAddEventOverlay() {
    setState(() {
      _showOverlay = true;
    });

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        bottom: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              // color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                getBackground(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                      color: MyColors.primary,
                      borderRadius: BorderRadius.circular(25)),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      backgroundColor: Colors.black12,
                      foregroundColor: MyColors.background,
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Add Event',
                              style: TextStyle(fontSize: 23),
                            ),
                            IconButton(
                              // padding:
                              //     const EdgeInsets.only(right: 20, bottom: 50),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                overlayEntry.remove();
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 30,
                              ),
                              // color: MyColors.background,
                            ),
                          ],
                        ),
                      ),

                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(20)),
                    ),
                    body: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                              color: MyColors.background, fontFamily: 'Outfit'),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Event Name'),
                              ),
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Event Date'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle submitting the form
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showAddEventOverlay,
      child: const Icon(
        Icons.add_rounded,
        color: MyColors.primary,
        size: 35,
      ),
    );
  }

  getBackground() {
    return
        // BackdropFilter(
        // filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        // child:
        const Opacity(
      opacity: 0.2,
      child: ModalBarrier(dismissible: false, color: Colors.black),
      // ),
    );
  }
}
