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

class AddQuizPage extends StatefulWidget {
  final List<dynamic> courses;
  final Event? event;
  final DateTime? initialDate;
  AddQuizPage({super.key, required this.courses, this.event, this.initialDate});

  @override
  _AddQuizPageState createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  // ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  // Create controllers for the form fields
  final _formKey = GlobalKey<FormState>();
  final _quizTitleController = TextEditingController();
  final _quizDescriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedValue;
  late List<dynamic> courses;

  late int _reminderValue;
  List<int?> reminderTimes = [
    -1,
    0,
    5,
    10,
    15,
    20,
    30,
    45,
    60,
    120,
  ];

  // Create variables to store the selected date and times
  late DateTime _selectedDate;
  late TimeOfDay _selectedFromTime;
  late TimeOfDay _selectedToTime;

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
      // _quizDescriptionController.text = widget.event!.description;
      _selectedValue = widget.event!.title.split(" ").join("");
      _quizDescriptionController.text = widget.event!.myDescription;
      _reminderValue = widget.event!.reminder;
    } else {
      debugPrint("Init dates and timw to now");
      _selectedDate = widget.initialDate ?? DateTime.now();
      _selectedFromTime = TimeOfDay.now();
      _selectedToTime = TimeOfDay.now();
      _reminderValue = 15;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _quizTitleController.dispose();
    _locationController.dispose();
    _quizDescriptionController.dispose();
  }

  buildDropdown() {
    return Container(
      // width: 180,
      height: 40,
      // margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          color: MyApp.isDarkMode.value
              ? MyColors.surface
              : const Color.fromARGB(255, 230, 230, 230),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2(
          iconStyleData: const IconStyleData(
              icon: Icon(Icons.arrow_drop_down_outlined), iconSize: 30),
          isExpanded: true,
          value: _selectedValue,
          style: TextStyle(
              color: MyApp.isDarkMode.value ? Colors.white70 : Colors.black54,
              fontFamily: 'Outfit',
              fontSize: 18,
              fontWeight: FontWeight.bold),

          dropdownStyleData: const DropdownStyleData(
              // offset: Offset(0, 3),
              decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          )),
          hint: Text("Select A Year"),
          alignment: Alignment.centerRight,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
          },
          // onSaved: (value) {
          //   setState(() {
          //     _selectedValue = value;
          //   });
          // },
          // validator: (String? value) {
          //   if (value == null || value.isEmpty) {
          //     return "    Please choose a course!";
          //   } else {
          //     return null;
          //   }
          // },
          items: widget.courses.map((dynamic course) {
            return DropdownMenuItem(
              value: course['code'] as String,
              child: Text(
                course['name'] ?? "",
              ),
            );
          }).toList(),
        ),
      ),
    );
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
          '${widget.event == null ? 'Add' : 'Edit'} Quiz',
          style: const TextStyle(fontSize: 25),
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
            // flex: 9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                          fontSize: 18,
                                          color: MyColors.secondary,
                                        ),
                                      ),
                                      Container(height: 5),
                                      DropdownButtonFormField2(
                                        value: _selectedValue,
                                        hint: const Text(
                                          'Select A Course',
                                        ),
                                        // decoration: InputDecoration(
                                        // constraints: const BoxConstraints(
                                        //     maxHeight: 40),
                                        // border: OutlineInputBorder(
                                        //   borderRadius:
                                        //       BorderRadius.circular(7.5),
                                        // ),
                                        // focusedBorder: OutlineInputBorder(
                                        //     borderRadius:
                                        //         BorderRadius.circular(7.5),
                                        //     borderSide: BorderSide(
                                        //         width: 2,
                                        //         color:
                                        //             MyColors.primaryVariant)),
                                        // contentPadding:
                                        //     const EdgeInsets.symmetric(
                                        //         vertical: 15),
                                        // ),
                                        // isExpanded: true,
                                        buttonStyleData: const ButtonStyleData(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                          ),
                                          padding:
                                              EdgeInsets.symmetric(vertical: 0),
                                        ),
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
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return "    Please choose a course!";
                                          } else {
                                            return null;
                                          }
                                        },
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

                                      // buildDropdown(),
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
                                          fontSize: 18,
                                          color: MyColors.secondary,
                                        ),
                                      ),
                                      Container(height: 5),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.text,
                                        controller: _quizTitleController,
                                        validator: (value) =>
                                            value != null && value.isEmpty
                                                ? 'Please enter a title'
                                                : null,
                                        style: const TextStyle(fontSize: 18),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          hintText: "e.g. Quiz 1",
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
                                  const SizedBox(height: 12),
                                  // make height of TextFormField 300

                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Description",
                                        style: TextStyle(
                                          fontFamily: "Outfit",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: MyColors.secondary,
                                        ),
                                      ),
                                      Container(height: 5),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        keyboardType: TextInputType.text,
                                        controller: _quizDescriptionController,
                                        // validator: (value) =>
                                        //     value != null && value.isEmpty
                                        //         ? 'Please enter a description'
                                        //         : null,
                                        style: const TextStyle(fontSize: 18),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          hintText:
                                              "e.g. Coming in Lectures X & Y",
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
                                fromPicker(),
                                toPicker(),
                              ],
                            ),

                            const Padding(
                              padding: EdgeInsets.only(top: 25, bottom: 15),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),

                            //// LOCATION ////
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Location",
                                    style: TextStyle(
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: MyColors.secondary,
                                    ),
                                  ),
                                  Container(height: 5),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    controller: _locationController,
                                    validator: (value) =>
                                        value != null && value.isEmpty
                                            ? 'Please enter a location'
                                            : null,
                                    style: const TextStyle(fontSize: 18),
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      hintText: "e.g. Exam Hall 1",
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
                                              color: MyColors.primaryVariant)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 7, horizontal: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            //// REMINDER ////
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reminder",
                                    style: TextStyle(
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: MyColors.secondary,
                                    ),
                                  ),
                                  Container(height: 5),
                                  DropdownButtonFormField2(
                                    value: _reminderValue,
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
                                              color: MyColors.primaryVariant)),
                                      contentPadding:
                                          const EdgeInsets.only(bottom: 5),
                                    ),
                                    isExpanded: true,
                                    buttonStyleData: const ButtonStyleData(
                                        height: 40,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5)),
                                    dropdownStyleData: const DropdownStyleData(
                                      isOverButton: true,
                                      maxHeight: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                      ),
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      selectedMenuItemBuilder:
                                          (context, child) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          child,
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: MyColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    onChanged: (value) {
                                      setState(() {
                                        _reminderValue = value as int;
                                      });
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        _reminderValue = value as int;
                                      });
                                    },
                                    items: reminderTimes.map((int? time) {
                                      String text = "";
                                      if (time != null) {
                                        if (time == -1) {
                                          text = "No Reminder";
                                        } else if (time == 0) {
                                          text = "On Time";
                                        } else if (time > 0 && time < 60) {
                                          text = "$time minutes before";
                                        } else if (time == 60) {
                                          text = "1 hour before";
                                        } else if (time == 120) {
                                          text = "2 hours before";
                                        }
                                      }
                                      return DropdownMenuItem(
                                        value: time,
                                        child: Text(text),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
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
              : Container(
                  alignment: FractionalOffset.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 40, top: 30),
                  width: 200,
                  // height: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      onDeletePresed();
                    },
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(10),
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
                            style:
                                TextStyle(fontSize: 17, color: MyColors.error),
                          ),
                        ]),
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
      Event quiz = Event(
        title: _selectedValue ?? "",
        description: _quizTitleController.text.trim(),
        start: date.add(Duration(
            hours: _selectedFromTime.hour, minutes: _selectedFromTime.minute)),
        end: date.add(Duration(
            hours: _selectedToTime.hour, minutes: _selectedToTime.minute)),
        location: _locationController.text,
        // color: Colors.blue,
        isAllDay: false,
        myDescription: _quizDescriptionController.text.trim(),
        reminder: _reminderValue,
      );
      Navigator.pop(context, quiz);
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
                isToPickerOpened = false;
                isFromPickerOpened = false;
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

  bool isFromPickerOpened = false;
  Widget fromPicker() {
    return Column(
      children: [
        TextButton(
            style: TextButton.styleFrom(
                // padding: EdgeInsets.all(0),
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.black26),
            onPressed: () {
              setState(() {
                isFromPickerOpened = !isFromPickerOpened;
                isToPickerOpened = false;
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
                    "From",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: MyColors.secondary,
                        fontSize: 20),
                  ),
                  Text(
                    _selectedFromTime.format(context),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: !isFromPickerOpened
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
            child: !isFromPickerOpened
                ? Container()
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      TimePickerSpinner(
                        time: DateTime.now().getDateOnly().add(Duration(
                            hours: _selectedFromTime.hour,
                            minutes: _selectedFromTime.minute)),
                        alignment: Alignment.center,
                        highlightedTextStyle: const TextStyle(fontSize: 25),
                        normalTextStyle: TextStyle(
                            fontSize: 20,
                            color: MyApp.isDarkMode.value
                                ? Colors.white30
                                : Colors.black54),
                        is24HourMode: false,
                        isForce2Digits: true,
                        minutesInterval: 5,
                        itemHeight: 40,
                        spacing: 20,
                        onTimeChange: (time) {
                          setState(() {
                            _selectedFromTime = TimeOfDay.fromDateTime(time);
                            if (_selectedToTime.compareTo(_selectedFromTime) <
                                0) {
                              _selectedToTime = _selectedFromTime;
                            }
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

  bool isToPickerOpened = false;
  Widget toPicker() {
    return Column(
      children: [
        TextButton(
            style: TextButton.styleFrom(
                // padding: EdgeInsets.all(0),
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.black26),
            onPressed: () {
              setState(() {
                isToPickerOpened = !isToPickerOpened;
                isDatePickerOpen = false;
                isFromPickerOpened = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "To",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: MyColors.secondary,
                        fontSize: 20),
                  ),
                  Text(
                    _selectedToTime.format(context),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: !isToPickerOpened
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
            child: !isToPickerOpened
                ? Container()
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      TimePickerSpinner(
                        time: DateTime.now().getDateOnly().add(Duration(
                            hours: _selectedToTime.hour,
                            minutes: _selectedToTime.minute)),
                        alignment: Alignment.center,
                        highlightedTextStyle: const TextStyle(fontSize: 25),
                        normalTextStyle: TextStyle(
                            fontSize: 20,
                            color: MyApp.isDarkMode.value
                                ? Colors.white30
                                : Colors.black54),
                        is24HourMode: false,
                        isForce2Digits: true,
                        minutesInterval: 5,
                        itemHeight: 40,
                        spacing: 20,
                        onTimeChange: (time) {
                          setState(() {
                            _selectedToTime = TimeOfDay.fromDateTime(time);
                            if (_selectedToTime.compareTo(_selectedFromTime) <
                                0) {
                              _selectedFromTime = _selectedToTime;
                            }
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
