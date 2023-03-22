import 'package:flutter/material.dart';
import 'package:gucentral/widgets/MyColors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AddQuizPage extends StatefulWidget {
  const AddQuizPage({super.key});

  @override
  _AddQuizPageState createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  // Create controllers for the form fields
  final _courseController = TextEditingController();
  final _quizTitleController = TextEditingController();
  final _locationController = TextEditingController();

  // Create variables to store the selected date and times
  late DateTime _selectedDate = DateTime.now();
  late TimeOfDay _selectedFromTime = TimeOfDay.now();
  late TimeOfDay _selectedToTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.primary,
        title: const Text(
          'Add Quiz',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
            color: MyColors.primary, backgroundColor: MyColors.accent),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Course selection dropdown
                DropdownButtonFormField<String>(
                  value: _courseController.text,
                  onChanged: (value) {
                    // setState(() {
                    _courseController.text = value!;
                    // });
                  },
                  items: [
                    // DropdownMenuItem(
                    //   value: 'Math',
                    //   child: Text('Math'),
                    // ),
                    // DropdownMenuItem(
                    //   value: 'Science',
                    //   child: Text('Science'),
                    // ),
                    // DropdownMenuItem(
                    //   value: 'English',
                    //   child: Text('English'),
                    // ),
                  ]
                  // ['Math', 'Science', 'English']
                  //     .map((course) => DropdownMenuItem(
                  //           value: course,
                  //           child: Text(course),
                  //         ))
                  //     .toList()
                  ,
                  decoration: InputDecoration(
                    labelText: 'Course',
                  ),
                ),
                // // Quiz title text field
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
      ),
    );
  }
}
