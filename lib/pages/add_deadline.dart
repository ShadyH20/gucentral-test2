import 'package:date_picker_widget/date_picker_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:gucentral/main.dart';
import 'package:gucentral/pages/schedule_page.dart';
import 'package:gucentral/widgets/MyColors.dart';
import 'package:gucentral/widgets/Requests.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}

class AddDeadlinePage extends StatefulWidget {
  final List<dynamic> courses;
  final Event? event;
  final DateTime? initialDate;
  AddDeadlinePage(
      {super.key, required this.courses, this.event, this.initialDate});

  @override
  _AddDeadlinePageState createState() => _AddDeadlinePageState();
}

class _AddDeadlinePageState extends State<AddDeadlinePage> {
  // ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  // Create controllers for the form fields
  final _formKey = GlobalKey<FormState>();
  final _deadlineTitleController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedValue;
  late List<dynamic> courses;

  // Create variables to store the selected date and times
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  // late TimeOfDay _selectedToTime;

  @override
  void initState() {
    super.initState();
    courses = widget.courses;

    if (widget.event != null) {
      _selectedDate = widget.event!.start;
      _selectedTime = TimeOfDay(
          hour: widget.event!.start.hour, minute: widget.event!.start.minute);

      _deadlineTitleController.text = widget.event!.description;
      _locationController.text = widget.event!.location;
      _selectedValue = widget.event!.title.split(" ").join("");
      if (_selectedValue == "") {
        _selectedValue = null;
      }
    } else {
      _selectedDate = widget.initialDate ?? DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _deadlineTitleController.dispose();
    _locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: MyColors.secondary,
        backgroundColor: MyColors.background,
        elevation: 0,
        title: Text(
          '${widget.event == null ? 'Add' : 'Edit'} Deadline',
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
                foregroundColor: MyColors.secondary,
                backgroundColor: MyColors.background,
                shadowColor: Colors.transparent),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                        // height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  //// COURSE ////
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Course",
                                        style: TextStyle(
                                          fontFamily: "Outfit",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: MyColors.secondary,
                                        ),
                                      ),
                                      Container(height: 5),
                                      DropdownButtonFormField2(
                                        value: _selectedValue,
                                        hint: const Text(
                                          'Select A Course',
                                        ),
                                        decoration: InputDecoration(
                                          constraints: const BoxConstraints(),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.5),
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  color:
                                                      MyColors.primaryVariant)),
                                          contentPadding:
                                              const EdgeInsets.only(bottom: 5),
                                        ),
                                        isExpanded: true,
                                        buttonStyleData: const ButtonStyleData(
                                            height: 40,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5)),
                                        dropdownStyleData:
                                            const DropdownStyleData(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                          ),
                                        ),
                                        alignment: Alignment.centerLeft,
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
                                        // validator: (String? value) {
                                        //   if (value == null || value.isEmpty) {
                                        //     return "    Please choose a course!";
                                        //   } else {
                                        //     return null;
                                        //   }
                                        // },
                                        items: widget.courses
                                            .map((dynamic course) {
                                          return DropdownMenuItem(
                                            value: course['code'] as String,
                                            child: Text(
                                              course['name'] ?? "",
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  //// QUIZ TITLE ////
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Title",
                                        style: TextStyle(
                                          fontFamily: "Outfit",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: MyColors.secondary,
                                        ),
                                      ),
                                      Container(height: 5),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        controller: _deadlineTitleController,
                                        validator: (value) =>
                                            value != null && value.isEmpty
                                                ? 'Please enter a title'
                                                : null,
                                        style: const TextStyle(fontSize: 18),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          hintText: "e.g. Milestone 1",
                                          hintStyle: TextStyle(
                                              fontFamily: "Outfit",
                                              fontWeight: FontWeight.w500,
                                              color: MyColors.secondary
                                                  .withOpacity(.15)),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.5),
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  color:
                                                      MyColors.primaryVariant)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 7, horizontal: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.only(top: 25, bottom: 15),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),

                            Column(
                              children: [
                                // Date picker
                                datePicker(),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Divider(thickness: 1.5),
                                ),
                                timePicker(),
                                // toPicker(),
                              ],
                            ),

                            // const Padding(
                            //   padding: EdgeInsets.only(top: 25, bottom: 15),
                            //   child: Divider(
                            //     thickness: 2,
                            //   ),
                            // ),

                            //// LOCATION ////
                            //           Padding(
                            //             padding:
                            //                 const EdgeInsets.symmetric(horizontal: 15.0),
                            //             child: Column(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceEvenly,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "Location",
                            //                   style: TextStyle(
                            //                     fontFamily: "Outfit",
                            //                     fontWeight: FontWeight.w500,
                            //                     fontSize: 20,
                            //                     color: MyColors.secondary,
                            //                   ),
                            //                 ),
                            //                 Container(height: 5),
                            //                 TextFormField(
                            //                   textInputAction: TextInputAction.next,
                            //                   keyboardType: TextInputType.text,
                            //                   controller: _locationController,
                            //                   validator: (value) =>
                            //                       value != null && value.isEmpty
                            //                           ? 'Please enter a location'
                            //                           : null,
                            //                   style: const TextStyle(fontSize: 18),
                            //                   textAlignVertical: TextAlignVertical.center,
                            //                   decoration: InputDecoration(
                            //                     hintText: "e.g. Exam Hall 1",
                            //                     hintStyle: TextStyle(
                            //                         fontFamily: "Outfit",
                            //                         fontWeight: FontWeight.w500,
                            //                         color: MyColors.secondary
                            //                             .withOpacity(.15)),
                            //                     border: OutlineInputBorder(
                            //                       borderRadius:
                            //                           BorderRadius.circular(7.5),
                            //                     ),
                            //                     focusedBorder: OutlineInputBorder(
                            //                         borderRadius:
                            //                             BorderRadius.circular(7.5),
                            //                         borderSide: BorderSide(
                            //                             width: 2,
                            //                             color: MyColors.primaryVariant)),
                            //                     contentPadding:
                            //                         const EdgeInsets.symmetric(
                            //                             vertical: 7, horizontal: 15),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //// DELETE BUTTON ////
          //  SizedBox(height: 40),
          widget.event == null
              ? Container()
              : Expanded(
                  flex: 2,
                  child: Container(
                    alignment: FractionalOffset.bottomCenter,
                    margin: const EdgeInsets.only(bottom: 40),
                    width: 200,
                    // height: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        onDeletePresed();
                      },
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          side: BorderSide(color: MyColors.error)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_rounded,
                              color: MyColors.error,
                              size: 25,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Delete",
                              style: TextStyle(
                                  fontSize: 17, color: MyColors.error),
                            ),
                          ]),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  onSavePressed() {
    bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      DateTime date = _selectedDate.getDateOnly();
      DateTime time = date.add(
          Duration(hours: _selectedTime.hour, minutes: _selectedTime.minute));

      Event deadline = Event(
        title: _selectedValue ?? "",
        description: _deadlineTitleController.text.trim(),
        start: time,
        end: time,
        // location: _locationController.text,
        isAllDay: false,
      );
      Navigator.pop(context, deadline);
    }
  }

  onDeletePresed() {
    Navigator.pop(context, 'Delete');
  }

  bool isDatePickerOpen = false;
  Widget datePicker() {
    return Column(
      children: [
        TextButton(
            style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.black26),
            onPressed: () {
              setState(() {
                isDatePickerOpen = !isDatePickerOpen;
                isTimePickerOpen = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: MyColors.secondary,
                        fontSize: 20),
                  ),
                  Text(
                    DateFormat("dd MMMM yyyy").format(_selectedDate),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: !isDatePickerOpen
                            ? MyColors.secondary
                            : MyColors.primary,
                        fontSize: 20),
                  ),
                ],
              ),
            )),
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.ease,
          child: !isDatePickerOpen
              ? Container()
              : TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2080, 3, 14),
                  startingDayOfWeek: StartingDayOfWeek.saturday,
                  weekendDays: [],
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: {CalendarFormat.month: 'Month'},
                  focusedDay: _selectedDate,
                  rowHeight: 35,
                  headerStyle: HeaderStyle(
                    leftChevronMargin: EdgeInsets.zero,
                    rightChevronMargin: EdgeInsets.zero,
                    leftChevronIcon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: MyColors.primary,
                      size: 20,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: MyColors.primary,
                      size: 20,
                    ),
                    headerPadding: const EdgeInsets.only(top: 8),
                    titleCentered: true,
                    titleTextFormatter: (date, locale) =>
                        DateFormat("MMMM yyyy").format(date).toUpperCase(),
                    titleTextStyle:
                        TextStyle(color: MyColors.primary, fontSize: 17),
                  ),
                  calendarStyle: CalendarStyle(
                    cellMargin: const EdgeInsets.symmetric(horizontal: 2),
                    defaultTextStyle: const TextStyle(fontSize: 18),
                    selectedTextStyle:
                        const TextStyle(fontSize: 18, color: Colors.white),
                    todayTextStyle:
                        TextStyle(fontSize: 18, color: MyColors.primary),
                    todayDecoration:
                        const BoxDecoration(shape: BoxShape.rectangle),
                    defaultDecoration:
                        const BoxDecoration(shape: BoxShape.rectangle),
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                      color: _selectedDate.getDateOnly() ==
                              DateTime.now().getDateOnly()
                          ? MyColors.primary
                          : const Color.fromARGB(255, 76, 78, 88)
                              .withOpacity(0.7),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDate, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        _selectedDate = selectedDay;
                      });
                    }
                  },
                ),
        )
      ],
    );
  }

  bool isTimePickerOpen = false;
  Widget timePicker() {
    return Column(
      children: [
        TextButton(
            style: TextButton.styleFrom(
                // padding: EdgeInsets.all(0),
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.black26),
            onPressed: () {
              setState(() {
                isTimePickerOpen = !isTimePickerOpen;
                isDatePickerOpen = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Time",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: MyColors.secondary,
                        fontSize: 20),
                  ),
                  Text(
                    _selectedTime.format(context),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: !isTimePickerOpen
                            ? MyColors.secondary
                            : MyColors.primary,
                        fontSize: 20),
                  ),
                ],
              ),
            )),
        AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
            child: !isTimePickerOpen
                ? Container()
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      TimePickerSpinner(
                        time: DateTime.now().getDateOnly().add(Duration(
                            hours: _selectedTime.hour,
                            minutes: _selectedTime.minute)),
                        alignment: Alignment.center,
                        highlightedTextStyle: const TextStyle(fontSize: 25),
                        normalTextStyle: TextStyle(
                            fontSize: 20,
                            color: context.isDarkMode
                                ? Colors.white30
                                : Colors.black54),
                        is24HourMode: false,
                        isForce2Digits: true,
                        // minutesInterval: 5,
                        itemHeight: 40,
                        spacing: 20,
                        onTimeChange: (time) {
                          setState(() {
                            _selectedTime = TimeOfDay.fromDateTime(time);
                            // if (_selectedToTime.compareTo(_selectedFromTime) <
                            //     0) {
                            //   _selectedToTime = _selectedFromTime;
                            // }
                          });
                        },
                      ),
                      // 2 LINES //
                      Column(
                        children: [
                          Divider(
                              thickness: 2,
                              height: 40,
                              indent: MediaQuery.of(context).size.width * 0.2,
                              endIndent:
                                  MediaQuery.of(context).size.width * 0.2),
                          Divider(
                              thickness: 2,
                              height: 40,
                              indent: MediaQuery.of(context).size.width * 0.2,
                              endIndent:
                                  MediaQuery.of(context).size.width * 0.2),
                        ],
                      )
                    ],
                  )),
      ],
    );
  }
}
