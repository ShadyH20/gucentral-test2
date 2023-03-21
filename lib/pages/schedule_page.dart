// ignore_for_file: avoid_print

import "dart:async";
import "dart:convert";
import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/AddEventOverlay.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:gucentral/widgets/Requests.dart";
import 'package:intl/intl.dart';
import "package:table_calendar/table_calendar.dart";
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/src/widgets/framework.dart';

import "../widgets/EventDataSource.dart";

extension DateTimeExtension on DateTime {
  DateTime getDateOnly() {
    return DateTime(year, month, day);
  }

  DateTime at8am() {
    return DateTime.utc(year, month, day, 7, 45);
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String formattedTime = DateFormat('kk:mm::ss').format(DateTime.now());
  String hour = DateFormat('a').format(DateTime.now());

  DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  Map<String, String> courseMap = {};
  List<dynamic> schedule = [];
  Map<int, List<Event>> groupedEvents = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  final CalendarController _controller = CalendarController();

  _SchedulePageState() {
    initializeSchedulePage();
  }

  initializeSchedulePage() async {
    await getSchedule();
    await createEvents();
    _eventDataSource = EventDataSource(events);
    print("Initialized Data Source");
    groupedEvents = groupEvents(events);
    // print("events today: ${groupedEvents[DateTime(2023, 3, 18)]}");
  }

  getSchedule() async {
    schedule = await Requests.getSchedule();
    Requests.getCourses().then((courses) {
      courseMap = {for (var course in courses) course['code']: course['name']};
      print("Course Map: $courseMap");
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    colorIndex = 0;
  }

  // OverlayEntry? _overlayEntry;

  // void _showOverlay() {
  //   // Store a reference to the OverlayEntry widget
  //   _overlayEntry = OverlayEntry(
  //     builder: (BuildContext context) => // ... add your overlay widget here
  //   );

  //   // Insert the OverlayEntry widget into the Overlay
  //   Overlay.of(context)?.insert(_overlayEntry!);
  // }

  // void _hideOverlay() {
  //   // Remove the OverlayEntry widget from the Overlay
  //   _overlayEntry?.remove();
  //   _overlayEntry = null;
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: scheduleAppBar(),
        body: Column(
          children: [
            // AddEventOverlay(),
            TableCalendar(
              eventLoader: (day) => _getEventsForDay(day),
              // enabledDayPredicate: (day) => day.weekday != dayIndexMap['Friday'],
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2080, 3, 14),
              startingDayOfWeek: StartingDayOfWeek.saturday,
              focusedDay: _selectedDay,
              calendarFormat: _calendarFormat,
              daysOfWeekVisible: _calendarFormat == CalendarFormat.month,
              rowHeight: _calendarFormat == CalendarFormat.week ? 90 : 60,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                  _controller.displayDate = selectedDay.at8am();
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) =>
                    defaultDayBuilder(context, date, _),
                selectedBuilder: (context, day, focusedDay) =>
                    selectedDayBuilder(context, day, focusedDay),
                todayBuilder: (context, day, focusedDay) =>
                    todayBuilder(context, day, focusedDay),
                markerBuilder: (context, day, events) => Container(),
                dowBuilder: (context, day) {
                  return Text(
                    DateFormat("EEE").format(day).toLowerCase(),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: true,
                isTodayHighlighted: true,
              ),
              headerStyle: HeaderStyle(
                titleTextStyle:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                titleCentered: true,
                titleTextFormatter: (date, locale) {
                  return DateFormat("MMMM ''yy").format(date);
                },
                formatButtonShowsNext: false,
              ),
              availableCalendarFormats: const {
                CalendarFormat.week: 'Week',
                CalendarFormat.month: 'Month',
              },
            ),
            //// TAB BUTTONS ////
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 1.1),
                          color: Colors.black26,
                          spreadRadius: 0.6)
                    ],
                    color: MyColors.background,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            clickTabBtn("Deadline");
                          },
                          child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: getTabBackColor(0),
                              ),
                              child: SvgPicture.asset(
                                "assets/images/deadline-new.svg",
                                height: 20,
                                color: getTabFrontColor(0),
                              ))),
                      Container(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            clickTabBtn("Q");
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: 28,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: getTabBackColor(1),
                              ),
                              child: Text(
                                "Q",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: getTabFrontColor(1)),
                              ))),
                    ],
                  ),
                ),
              ),
            ),
            tabIndex == 0
                ? Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 90,
                    color: MyColors.accent,
                  )
                : tabIndex == 1
                    ? Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 65,
                        child: quizBuilder(),
                      )
                    : Container(
                        height: 10,
                      ),

            //// DAY VIEW ////
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 25),
                // color: MyColors.accent,
                child: _eventDataSource
                        .getVisibleAppointments(
                            _controller.displayDate ?? DateTime.now(), '')
                        .isEmpty
                    ? const Align(
                        alignment: FractionalOffset(0.5, 0.1),
                        child: Text(
                          "No Classes Today!",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: MyColors.secondary),
                        ),
                      )
                    : SfCalendar(
                        controller: _controller,
                        view: CalendarView.day,
                        viewNavigationMode: ViewNavigationMode.none,
                        initialDisplayDate: DateTime.now(),
                        initialSelectedDate: DateTime.now(),
                        todayHighlightColor: MyColors.primary,
                        //       // cellBorderColor: Colors.transparent,
                        viewHeaderHeight: 0,
                        headerHeight: 0,
                        showCurrentTimeIndicator: true,
                        selectionDecoration: const BoxDecoration(
                          color: Colors.transparent,
                          border: Border(),
                        ),
                        //onViewChanged: (details) {
                        //setState(() {
                        //  _selectedDay = _controller.displayDate ?? _selectedDay;
                        // });
                        //},
                        timeSlotViewSettings: const TimeSlotViewSettings(
                            startHour: 7,
                            endHour: 19,
                            timeInterval: Duration(hours: 1),
                            timeIntervalHeight: 65,
                            timeFormat: "h a",
                            timeRulerSize: 40,
                            timeTextStyle: TextStyle(
                                color: MyColors.secondary,
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                            nonWorkingDays: <int>[
                              DateTime.friday,
                            ]),
                        dataSource: _eventDataSource,
                        appointmentBuilder: appointmentBuilder,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ############################
// ####### PAGE WIDGETS #######
// ############################
  AppBar scheduleAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: MyColors.background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark),
      elevation: 0,
      backgroundColor: MyColors.background,
      centerTitle: true,
      leadingWidth: 60.0,
      leading: const MenuWidget(),
      title: const Text(
        // DateFormat("MMMM").format(DateTime.now()),
        "Schedule",
        style: TextStyle(color: MyColors.primary),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/images/today.svg",
            height: 28,
            color: MyColors.secondary,
          ),
          onPressed: () {
            setState(() {
              _selectedDay = DateTime.now().at8am();
            });
            _controller.displayDate = _selectedDay;
          },
        ),
        AddEventOverlay(),
        Container(
          width: 15,
        )
      ],
    );
  }

  Container eventBlock(Event event) {
    double durMin = event.end.difference(event.start).inMinutes.toDouble();
    return Container(
      height: durMin * 1.1,
      decoration: const BoxDecoration(
        color: Color(0xffdbf2fd),
      ),
      child: Text(event.title),
    );
  }

  List<Widget> getDayIcons(DateTime date, bool isSelected) {
    int rem = date.day % 3;
    Color color = isSelected ? MyColors.background : MyColors.primary;
    Widget deadline = SvgPicture.asset(
      "assets/images/deadline-new.svg",
      height: 15,
      color: color,
    );
    if (rem == 1) {
      return [
        Container(
          height: 15,
        )
      ];
    }
    if (rem == 0) {
      return [deadline];
    }
    return [
      deadline,
      Text(
        "Q",
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      )
    ];
  }

  selectedDayBuilder(BuildContext context, DateTime day, DateTime focusedDay) {
    return DefaultTextStyle(
      style: const TextStyle(color: MyColors.background),
      child: Container(
        margin: _calendarFormat == CalendarFormat.week
            ? const EdgeInsets.only(bottom: 15, left: 2, right: 2)
            : const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: (day.year == DateTime.now().year &&
                    day.month == DateTime.now().month &&
                    day.day == DateTime.now().day)
                ? MyColors.primary
                : const Color.fromARGB(255, 76, 78, 88).withOpacity(0.6),
            borderRadius: BorderRadius.circular(7)),
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getDayIcons(focusedDay, true),
            ),
            // Container(height: 5),
            Text(
              '${focusedDay.day}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                // color: MyColors.background),
              ),
            ),
            _calendarFormat == CalendarFormat.week
                ? Text(DateFormat('EEE').format(focusedDay).toLowerCase())
                : Container(),
          ],
        ),
      ),
    );
  }

  todayBuilder(BuildContext context, DateTime day, DateTime focusedDay) {
    return DefaultTextStyle(
      style: const TextStyle(color: Color.fromARGB(255, 95, 95, 95)),
      child: Stack(
        alignment: FractionalOffset.bottomCenter,
        children: [
          Container(
            color: Colors.transparent,
            margin: EdgeInsets.only(
                bottom: _calendarFormat == CalendarFormat.week ? 15 : 0),
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getDayIcons(day, false),
                ),
                // Container(height: 5),
                Text(
                  '${day.day}',
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color:
                          // Color.fromARGB(255, 255, 149, 0)
                          MyColors.accent),
                ),
                _calendarFormat == CalendarFormat.week
                    ? Text(DateFormat('EEE').format(day).toLowerCase())
                    : Container(),
              ],
            ),
          ),
          _calendarFormat == CalendarFormat.week
              ? const Positioned(
                  bottom: -2,
                  height: 30,
                  child:
                      //  Text(
                      //   "today",
                      //   style: TextStyle(fontSize: 15,),
                      // )
                      Icon(
                    Icons.arrow_drop_up_rounded,
                    size: 30,
                    color: MyColors.primary,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  defaultDayBuilder(BuildContext context, DateTime date, DateTime dateTime) {
    return DefaultTextStyle(
      style: const TextStyle(color: Color.fromARGB(255, 95, 95, 95)),
      child: Container(
        margin: EdgeInsets.only(
            bottom: _calendarFormat == CalendarFormat.week ? 15 : 0),
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getDayIcons(date, false),
            ),
            Text(
              '${date.day}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            _calendarFormat == CalendarFormat.week
                ? Text(DateFormat('EEE').format(date).toLowerCase())
                : Container(),
          ],
        ),
      ),
    );
  }

// ###########################
// ######### METHODS #########
// ###########################
  int tabIndex = 2;
  clickTabBtn(String btn) {
    if (btn == "Q") {
      setState(() {
        tabIndex = tabIndex == 1 ? 2 : 1;
      });
    } else if (btn == "Deadline") {
      setState(() {
        tabIndex = tabIndex == 0 ? 2 : 0;
      });
    } else {
      setState(() {
        tabIndex = 2;
      });
    }
  }

  getTabBackColor(int index) {
    return tabIndex == index ? MyColors.primary : Colors.black12;
  }

  getTabFrontColor(int index) {
    return tabIndex == index ? MyColors.background : MyColors.secondary;
  }

  Map<String, int> dayIndexMap = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday:': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

  List<String> timeSlots = [
    '8:15-9:45',
    '10:00-11:30',
    '11:45-13:15',
    '13:45-15:15',
    '15:45-17:15'
  ];

  List<Event> events = [];
  EventDataSource _eventDataSource = EventDataSource([]);

  DateTime getTime(int dayIndex, String timeString) {
    int hour = int.parse(timeString.split(":")[0]);
    int minute = int.parse(timeString.split(":")[1]);
    return DateTime.now()
        .getDateOnly()
        .add(Duration(days: dayIndex - DateTime.now().weekday))
        .add(Duration(hours: hour, minutes: minute));
  }

  createEvents() {
    for (int i = 0; i < schedule.length; i++) {
      String day = schedule[i][0];
      int dayIndex = dayIndexMap[day]!;

      for (int j = 1; j < schedule[i].length; j++) {
        if (schedule[i][j] is List) {
          String timeSlot = timeSlots[j - 1];
          String eventTitle = schedule[i][j][2];
          String eventDescription = schedule[i][j][3];
          String eventLocation = schedule[i][j][1];

          // Convert the time slot to start and end times
          DateTime startTime = getTime(dayIndex, timeSlot.split("-")[0].trim());
          DateTime endTime = getTime(dayIndex, timeSlot.split("-")[1].trim());

          // Create the event and add it to the list
          Event event = Event(
              title: eventTitle,
              description: eventDescription,
              start: startTime,
              end: endTime,
              color: Colors.lightBlue,
              isAllDay: false,
              recurrence: "FREQ=DAILY;INTERVAL=7",
              location: eventLocation);
          events.add(event);
        }
      }
    }
    print("Events $events");
    // _eventDataSource = EventDataSource(events);
  }

  Map<int, List<Event>> groupEvents(List<Event> events) {
    Map<int, List<Event>> groupedEvents = {};

    for (Event event in events) {
      DateTime startDate =
          DateTime(event.start.year, event.start.month, event.start.day);
      if (!groupedEvents.containsKey(startDate.weekday)) {
        groupedEvents[startDate.weekday] = [];
      }
      groupedEvents[startDate.weekday]?.add(event);
    }

    return groupedEvents;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return groupedEvents[day.weekday] ?? [];
  }

  int colorIndex = 0;
  List<Color> colors = const [
    Color(0xffdbf2fd),
    Color(0xffECDBFD),
    Color(0xffFDDBDB),
    Color(0xffFDFADB)
  ];
  getColor() {
    var res = colors[colorIndex];
    colorIndex++;
    if (colorIndex >= colors.length) {
      colorIndex = 0;
    }
    return res;
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    Appointment event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      margin: const EdgeInsets.only(left: 15),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: getColor(),
        borderRadius: BorderRadius.circular(13),
      ),
      child: DefaultTextStyle(
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'Outfit'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(event.notes.toString()),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/location.svg",
                        height: 11,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 3),
                      Text(event.location ?? "No Loc")
                    ],
                  ),
                ],
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  // courseMap[event.subject] ?? "",
                  courseMap[event.subject.split(' ').join('')] ??
                      "No Course Found",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                  "${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}")
            ],
          )),
    );
  }

  List<Event> quizzes = [
    Event(
        title: "CSEN 604",
        description: "Quiz 1",
        start: DateTime.now(),
        end: DateTime.now().add(Duration(hours: 1, minutes: 30)),
        color: Colors.green,
        location: "H19",
        isAllDay: false),
    Event(
        title: "CSEN 603",
        description: "Quiz 2",
        start: DateTime.now(),
        end: DateTime.now().add(Duration(hours: 1, minutes: 30)),
        color: Colors.green,
        location: "Exam Hall 1",
        isAllDay: false),
    Event(
        title: "CSEN 603",
        description: "Quiz 2",
        start: DateTime.now(),
        end: DateTime.now().add(Duration(hours: 1, minutes: 30)),
        color: Colors.green,
        location: "Exam Hall 1",
        isAllDay: false),
  ];

  Widget quizBuilder() {
    List<Appointment>? dayQuizzes = EventDataSource(quizzes)
        .getVisibleAppointments(_controller.displayDate ?? DateTime.now(), '');
    return dayQuizzes.isEmpty
        ? const Center(
            child: Text(
              "No Quizzes Today!",
              style: TextStyle(
                  color: MyColors.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListView.builder(
              // controller: _scrollController,
              scrollDirection: Axis.horizontal,
              // shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: dayQuizzes.length,
              itemBuilder: (BuildContext context, int index) {
                Appointment event = dayQuizzes[index];
                return Container(
                  width: 190,
                  // height: 65,
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
                  decoration: BoxDecoration(
                    color: MyColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DefaultTextStyle(
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: MyColors.background,
                          fontFamily: 'Outfit'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              // courseMap[event.subject] ?? "",
                              courseMap[event.subject.split(' ').join('')] ??
                                  "No Course Found",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text("~ ${event.notes.toString()} ~",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w900)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}"),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/location.svg",
                                    height: 11,
                                    color: MyColors.background,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(event.location ?? "No Loc")
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
                );
              },
            ),
          );
  }
}
