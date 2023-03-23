// ignore_for_file: avoid_print

import "dart:async";
import "dart:convert";
import "dart:ui";
import "package:dropdown_button2/dropdown_button2.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/pages/new_quiz.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:gucentral/widgets/Requests.dart";
import 'package:intl/intl.dart';
import "package:rotating_icon_button/rotating_icon_button.dart";
import "package:table_calendar/table_calendar.dart";
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
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

  DateTime _selectedDay = DateTime.now().at8am();
  DateTime _focusedDay = DateTime.now().at8am();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  Map<String, String> courseMap = {};
  List<dynamic> courses = [];
  List<dynamic> schedule = [];
  Map<int, List<Event>> groupedEvents = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  final CalendarController _controller = CalendarController();

  late EventDataSource _quizDataSource;
  late EventDataSource _deadlineDataSource;

  initializeSchedulePage() async {
    await getSchedule();
    await createEvents();
    _eventDataSource = EventDataSource(events);
    _quizDataSource = EventDataSource(quizzes);
    _deadlineDataSource = EventDataSource(deadlines);
    _controller.displayDate = _selectedDay;
    groupedEvents = groupEvents(events);
    // print("events today: ${groupedEvents[DateTime(2023, 3, 18)]}");
  }

  getSchedule() async {
    schedule = await Requests.getSchedule();
    Requests.getCourses().then((coursesR) {
      courseMap = {for (var course in coursesR) course['code']: course['name']};
      courses = coursesR;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeSchedulePage();
      setState(() {});
    });
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    colorIndex = 0;
  }

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
              // formatAnimationDuration: Duration(milliseconds: 500),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              daysOfWeekVisible: _calendarFormat == CalendarFormat.month,
              rowHeight: _calendarFormat == CalendarFormat.week ? 75 : 50,
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
                setState(() {
                  _focusedDay = focusedDay;
                });
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
                tablePadding: EdgeInsets.symmetric(vertical: 8),
                outsideDaysVisible: true,
                isTodayHighlighted: true,
              ),
              headerVisible: false,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.week: 'Week',
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: tabIndex == 0
                  ? 50
                  : tabIndex == 1
                      ? 65
                      : 0,
              margin: tabIndex == 2 ? null : const EdgeInsets.only(top: 5),
              child: tabIndex == 0
                  ? deadlineBuilder()
                  : tabIndex == 1
                      ? quizBuilder()
                      : null,
            ),
            Container(
              height: 10,
            ),

            //// DAY VIEW ////
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 25),
                decoration: BoxDecoration(
                    border: _eventDataSource
                            .getVisibleAppointments(
                                _controller.displayDate!, '')
                            .isEmpty
                        ? const Border(top: BorderSide(color: Colors.black12))
                        : null),
                child: Column(
                  children: [
                    _eventDataSource
                            .getVisibleAppointments(
                                _controller.displayDate!, '')
                            .isEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: const Text(
                              "No Classes Today!",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: MyColors.secondary),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: SfCalendar(
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
                  ],
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
      title: TextButton(
        onPressed: () {
          setState(() {
            _calendarFormat = _calendarFormat == CalendarFormat.week
                ? CalendarFormat.month
                : CalendarFormat.week;
          });
        },
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(5)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            // splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateColor.resolveWith(
                (states) => MyColors.primaryVariant.withOpacity(0.02))),
        child: Text(
          // DateFormat("MMMM").format(DateTime.now()),
          DateFormat("MMMM").format(_focusedDay),
          style: const TextStyle(
              color: MyColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 30),
        ),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            "assets/images/today.svg",
            height: 26,
            color: MyColors.secondary,
          ),
          onPressed: () {
            setState(() {
              _selectedDay = DateTime.now().at8am();
              _focusedDay = _selectedDay;
            });
            _controller.displayDate = _selectedDay;
          },
        ),
        addDropdown(),
        Container(
          width: 10,
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
    List<Appointment>? dayDeadlines =
        _deadlineDataSource.getVisibleAppointments(date, '');
    List<Appointment>? dayQuizzes =
        _quizDataSource.getVisibleAppointments(date, '');
    Color color = isSelected ? MyColors.background : MyColors.primary;
    double size = 12;
    Widget deadline = SvgPicture.asset(
      "assets/images/deadline-new.svg",
      height: 12,
      color: color,
    );

    List<Widget> icons = [];
    if (dayDeadlines.isNotEmpty) {
      icons.add(deadline);
    }
    if (dayQuizzes.isNotEmpty) {
      icons.add(Text(
        "Q",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: color, fontSize: size),
      ));
    }

    if (icons.isEmpty) {
      icons.add(Container(height: 12));
    }

    return icons;
  }

  selectedDayBuilder(BuildContext context, DateTime day, DateTime selectedDay) {
    bool isWeek = _calendarFormat == CalendarFormat.week;
    return DefaultTextStyle(
      style: const TextStyle(color: MyColors.background),
      child: Container(
        margin: isWeek
            ? const EdgeInsets.only(left: 2, right: 2)
            : const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: (day.year == DateTime.now().year &&
                    day.month == DateTime.now().month &&
                    day.day == DateTime.now().day)
                ? MyColors.primary
                : const Color.fromARGB(255, 76, 78, 88).withOpacity(0.6),
            borderRadius: BorderRadius.circular(7)),
        padding: EdgeInsets.symmetric(vertical: isWeek ? 7 : 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getDayIcons(day, true),
            ),
            // Container(height: 5),
            Text(
              '${day.day}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                // color: MyColors.background),
              ),
            ),
            isWeek
                ? Text(DateFormat('EEE').format(day).toLowerCase())
                : Container(),
          ],
        ),
      ),
    );
  }

  todayBuilder(BuildContext context, DateTime day, DateTime focusedDay) {
    bool isWeek = _calendarFormat == CalendarFormat.week;
    return DefaultTextStyle(
      style: const TextStyle(color: Color.fromARGB(255, 95, 95, 95)),
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.all(0),
        padding: EdgeInsets.symmetric(vertical: isWeek ? 7 : 2),
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
    );
  }

  defaultDayBuilder(BuildContext context, DateTime date, DateTime dateTime) {
    bool isWeek = _calendarFormat == CalendarFormat.week;
    return DefaultTextStyle(
      style: const TextStyle(color: Color.fromARGB(255, 95, 95, 95)),
      child: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.symmetric(vertical: isWeek ? 7 : 2),
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
    // print("Events $events");
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
    List<Appointment>? dayQuizzes = _quizDataSource.getVisibleAppointments(
        _controller.displayDate ?? DateTime.now(), '');
    return dayQuizzes.isEmpty
        ? const Center(
            child: Text(
              "No Quizzes Today!",
              style: TextStyle(
                color: MyColors.secondary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
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

  List<Event> deadlines = [
    Event(
        title: "CSEN 604",
        description: "Milestone I",
        start: DateTime.now().at8am().add(const Duration(hours: 15)),
        end: DateTime.now().at8am().add(const Duration(hours: 15)),
        color: Colors.green,
        // location: "H19",
        isAllDay: false),
    Event(
        title: "CSEN 603",
        description: "Milestone II",
        start: DateTime.now(),
        end: DateTime.now().at8am().add(const Duration(hours: 1, minutes: 30)),
        color: Colors.green,
        location: "Exam Hall 1",
        isAllDay: false),
    Event(
        title: "CSEN 601",
        description: "Teams Form",
        start:
            DateTime.now().add(const Duration(days: 1, hours: 1, minutes: 30)),
        end: DateTime.now().add(const Duration(days: 1, hours: 1, minutes: 30)),
        color: Colors.green,
        // location: "Exam Hall 1",
        isAllDay: false),
  ];

  Widget deadlineBuilder() {
    List<Appointment>? dayDeadlines = _deadlineDataSource
        .getVisibleAppointments(_controller.displayDate ?? DateTime.now(), '');
    return dayDeadlines.isEmpty
        ? const Center(
            child: Text(
              "No Deadlines Today!",
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
              itemCount: dayDeadlines.length,
              itemBuilder: (BuildContext context, int index) {
                Appointment event = dayDeadlines[index];
                return Container(
                  // width: 160,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: MyColors.background,
                          fontFamily: 'Outfit'),
                      child: IntrinsicWidth(
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
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(event.notes.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  Container(width: 10),
                                  Text(
                                      DateFormat('h:mm a')
                                          .format(event.endTime),
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontSize: 11,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              },
            ),
          );
  }

  double addIconTurns = 0.0;
  //// ADD EVENT DROPDOWN ////
  addDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: AnimatedRotation(
          turns: addIconTurns,
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
          child: const Icon(
            Icons.add_rounded,
            color: MyColors.primary,
            size: 35,
          ),
        ),
        // iconStyleData: const IconStyleData(
        //     icon: Icon(Icons.arrow_drop_down_outlined), iconSize: 30),
        isExpanded: true,
        value: dropdownValue,
        style: const TextStyle(
            // decoration: TextDecoration.underline,
            color: Colors.black54,
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.bold),
        // dropdownColor: MyColors.secondary,
        dropdownStyleData: DropdownStyleData(
            openInterval: const Interval(0, .75, curve: Curves.easeIn),
            elevation: 8,
            offset: const Offset(0, 5),
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            )),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        // underline: Container(
        //   color: const Color(0),
        // ),

        onChanged: (String? value) async {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
          if (dropdownValue == "Quiz") {
            var quiz = await goToAddQuiz();
            // print(quiz.toString());
            quizzes.add(quiz);
            setState(() {});
          }
        },
        onMenuStateChange: (isOpen) {
          if (isOpen) {
            setState(() {
              addIconTurns += 3.0 / 8.0;
            });
          } else {
            setState(() {
              addIconTurns -= 3.0 / 8.0;
            });
          }
        },
        items: [
          DropdownMenuItem(
            value: "Quiz",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 20,
                  child: const Text(
                    "Q",
                    style: TextStyle(color: MyColors.primary),
                  ),
                ),
                Container(width: 10),
                const Text("Add Quiz/Exam")
              ],
            ),
          ),
          DropdownMenuItem(
            value: "Deadline",
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/deadline-new.svg",
                  width: 20,
                  color: MyColors.primary,
                  // height: 20,
                ),
                Container(width: 10),
                const Text("Add Deadline")
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showAddEventOverlay() async {
    String result = await displayCupertino();
    print(result);
    if (result == "Quiz") {
      var quiz = await goToAddQuiz();
      print(quiz.toString());
      quizzes.add(quiz);
      setState(() {});
    }
  }

  Future<Event> goToAddQuiz() async {
    print("Schedule Page: $courses");
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddQuizPage(
                  courses: courses,
                )));
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
                        color: MyColors.primary,
                      )),
                  SizedBox(width: 15),
                  Text('New Quiz/Exam',
                      style: TextStyle(color: MyColors.secondary)),
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
                      color: MyColors.primary,
                    ),
                    SizedBox(width: 15),
                    Text('New Deadline',
                        style: TextStyle(color: MyColors.secondary)),
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
}

const List<String> list = ['Add Quiz/Exam', 'Add Deadline'];
String? dropdownValue;
