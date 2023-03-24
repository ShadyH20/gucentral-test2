import 'package:flutter/material.dart';
import 'package:gucentral/pages/schedule_page.dart';
import 'package:gucentral/widgets/MyColors.dart';
import 'package:gucentral/widgets/Requests.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AddQuizPage extends StatefulWidget {
  final List<dynamic> courses;
  final Event? event;
  const AddQuizPage({super.key, required this.courses, this.event});

  @override
  _AddQuizPageState createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  // Create controllers for the form fields
  final _formKey = GlobalKey<FormState>();
  final _quizTitleController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedValue;
  late List<dynamic> courses;

  // Create variables to store the selected date and times
  late DateTime _selectedDate = DateTime.now();
  late TimeOfDay _selectedFromTime = TimeOfDay.now();
  late TimeOfDay _selectedToTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    courses = widget.courses;

    if (widget.event != null) {
      _selectedDate = widget.event!.start;
      _selectedFromTime = TimeOfDay(
          hour: widget.event!.start.hour, minute: widget.event!.start.minute);
      _selectedToTime = TimeOfDay(
          hour: widget.event!.end.hour, minute: widget.event!.end.minute);
      _quizTitleController.text = widget.event!.description;
      _locationController.text = widget.event!.location;
      _selectedValue = widget.event!.title.split(" ").join("");
    } else {
      _selectedDate = DateTime.now();
      _selectedFromTime = TimeOfDay.now();
      _selectedToTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _quizTitleController.dispose();
    _locationController.dispose();
  }

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
        actions: [
          TextButton.icon(
            onPressed: () {
              onSavePressed();
            },
            icon: const Icon(
              Icons.done_rounded,
              size: 25,
            ),
            label: const Text(
              "Save",
              style: TextStyle(fontSize: 17),
            ),
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                foregroundColor: MyColors.background,
                backgroundColor: MyColors.primary,
                shadowColor: Colors.transparent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Course selection dropdown
                DropdownButtonFormField(
                  value: _selectedValue,
                  hint: const Text(
                    'Select A Course',
                  ),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please choose a course!";
                    } else {
                      return null;
                    }
                  },
                  items: widget.courses.map((dynamic course) {
                    return DropdownMenuItem(
                      value: course['code'] as String,
                      child: Text(
                        course['name'] ?? "",
                      ),
                    );
                  }).toList(),
                ),
                // // Quiz title text field
                TextFormField(
                  controller: _quizTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Quiz Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Quiz title cannot be empty!";
                    } else {
                      return null;
                    }
                  },
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
                  decoration: const InputDecoration(
                    labelText: 'Location',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Location cannot be empty!";
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onSavePressed() {
    bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      DateTime date = _selectedDate.getDateOnly();
      Event quiz = Event(
        title: _selectedValue ?? "",
        description: _quizTitleController.text.trim(),
        start: date.add(Duration(
            hours: _selectedFromTime.hour, minutes: _selectedFromTime.minute)),
        end: date.add(Duration(
            hours: _selectedToTime.hour, minutes: _selectedToTime.minute)),
        location: _locationController.text,
        color: Colors.blue,
        isAllDay: false,
      );
      Navigator.pop(context, quiz);
    }
  }
}
