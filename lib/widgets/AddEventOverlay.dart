import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../pages/new_quiz.dart';
import 'MyColors.dart';
// import 'package:flutter_overlay_library/flutter_overlay_library.dart';

class AddEventOverlay extends StatefulWidget {
  @override
  _AddEventOverlayState createState() => _AddEventOverlayState();
}

class _AddEventOverlayState extends State<AddEventOverlay> {
  bool _showOverlay = false;
  late OverlayEntry overlayEntry;

  Future<void> _showAddEventOverlay() async {
    String result = await displayCupertino();
    print(result);
    if (result == "Quiz") {
      _goToAddQuiz();
    }
    // _showAddEventOverlay2();
  }

  void _goToAddQuiz() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddQuizPage()));
  }

  void _showAddEventOverlay2() {
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
                    child: addQuizPage(context)),
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

  displayCupertino() async {
    return await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          // title: const Text('Add Event'),
          // message: const Text('Your options are '),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Q",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      )),
                  SizedBox(width: 15),
                  Text('New Quiz/Exam'),
                ],
              ),
              onPressed: () {
                Navigator.pop(context, 'Quiz');
              },
            ),
            CupertinoActionSheetAction(
              child: Container(
                // width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/deadline-new.svg",
                      height: 20,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 15),
                    Text('New Deadline'),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.pop(context, 'Deadline');
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          )),
    );
  }

// Create controllers for the form fields
  final _courseController = TextEditingController();
  final _quizTitleController = TextEditingController();
  final _locationController = TextEditingController();

  // Create variables to store the selected date and times
  late DateTime _selectedDate = DateTime.now();
  late TimeOfDay _selectedFromTime = TimeOfDay.now();
  late TimeOfDay _selectedToTime = TimeOfDay.now();

  Widget addQuizPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Quiz'),
        actions: [
          IconButton(
              onPressed: () {
                overlayEntry.remove();
              },
              icon: Icon(Icons.close_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Course selection dropdown
              DropdownButtonFormField<String>(
                value: _courseController.text.isNotEmpty
                    ? _courseController.text
                    : null,
                onChanged: (value) {
                  setState(() {
                    _courseController.text = value!;
                  });
                },
                items: ['Math', 'Science', 'English']
                    .map((course) => DropdownMenuItem(
                          value: course,
                          child: Text(course),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Course',
                ),
              ),
              // Quiz title text field
              TextFormField(
                controller: _quizTitleController,
                decoration: InputDecoration(
                  labelText: 'Quiz Title',
                ),
              ),

              // Date picker
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
                child: Text(_selectedDate == null
                    ? 'Select Date'
                    : 'Selected Date: ${_selectedDate.toString()}'),
              ),

              // From time picker
              TextButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      _selectedFromTime = time;
                    });
                  }
                },
                child: Text(_selectedFromTime == null
                    ? 'Select From Time'
                    : 'Selected From Time: ${_selectedFromTime.format(context)}'),
              ),

              // To time picker
              TextButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      _selectedToTime = time;
                    });
                  }
                },
                child: Text(_selectedToTime == null
                    ? 'Select To Time'
                    : 'Selected To Time: ${_selectedToTime.format(context)}'),
              ),

              // Location text field
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
              ),

              // Add quiz button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement quiz creation logic
                },
                child: Text('Add Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
