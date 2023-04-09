// ignore_for_file: avoid_print

import "dart:async";
import "dart:convert";
import "dart:math";
import "dart:ui";
import "package:auto_size_text/auto_size_text.dart";
import "package:dropdown_button2/dropdown_button2.dart";
import "package:fading_edge_scrollview/fading_edge_scrollview.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/pages/new_quiz.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import "package:gucentral/widgets/Requests.dart";
import "package:hijri/hijri_calendar.dart";
import 'package:intl/intl.dart';
import "package:table_calendar/table_calendar.dart";
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import "../main.dart";
import "../widgets/EventDataSource.dart";
import "../utils/SharedPrefs.dart";

extension DateTimeExtension on DateTime {
  DateTime getDateOnly() {
    return DateTime(year, month, day);
  }

  DateTime at8am() {
    return DateTime.utc(year, month, day, 7, 45);
  }
}

List<Color> colors = const [
  Color(0xffdbf2fd),
  Color(0xffECDBFD),
  Color(0xffFDDBDB),
  Color(0xffFDFADB)
];

class SchedulePage extends StatefulWidget {
  final VoidCallback notifyHomePage;
  const SchedulePage({super.key, required this.notifyHomePage});

  @override
  State<SchedulePage> createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  String formattedTime = DateFormat('kk:mm::ss').format(DateTime.now());
  String hour = DateFormat('a').format(DateTime.now());

  DateTime _selectedDay = DateTime.now().at8am();
  DateTime _focusedDay = DateTime.now().at8am();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  bool is24h = false;

  late List<String> timeSlots;
  Map<String, String> courseMap = {};
  List<dynamic> courses = [];
  List<dynamic> schedule = [];
  Map<int, List<Event>> groupedEvents = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  final CalendarController _controller = CalendarController();

  late EventDataSource _quizDataSource;
  late EventDataSource _deadlineDataSource;

  initializeSchedulePage() {
    _controller.displayDate = DateTime.now().at8am();
    setTimeSlots();
    getSchedule();

    createEvents();
    _eventDataSource = EventDataSource(events + quizzes);
    _quizDataSource = EventDataSource(quizzes);
    _deadlineDataSource = EventDataSource(deadlines);
    _controller.displayDate = _selectedDay;
    groupedEvents = groupEvents(events);
    getExamSchedule();
    setState(() {});
  }

  getSchedule() {
    schedule = Requests.getSchedule();
    var coursesR = Requests.getCourses();
    courseMap = {for (var course in coursesR) course['code']: course['name']};
    courses = coursesR;
  }

// ignore: non_constant_identifier_names
  late ColorScheme MyColors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyColors = Theme.of(context).colorScheme;
  }

  bool delayed3rd = prefs.getBool('delayed_3rd') ?? false;
  @override
  void initState() {
    super.initState();
    initializeSchedulePage();
    setState(() {});
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    colorIndex = 0;
  }

  void setTimeSlots() {
    var today = HijriCalendar.now();
    print(today.hMonth);
    // Check if we are in Ramadan
    if (today.hMonth == 9) {
      timeSlots = [
        '9:00-10:10',
        '10:15-11:25',
        '11:30-12:40',
        '12:50-14:00',
        '14:05-15:15'
      ];
      return;
    }

    bool delayed = prefs.getBool('delayed_3rd') ?? false;

    timeSlots = [
      '8:15-9:45',
      '10:00-11:30',
      delayed ? '12:00-13:30' : '11:45-13:15',
      '13:45-15:15',
      '15:45-17:15'
    ];
  }

  @override
  Widget build(BuildContext context) {
    // If delayed 3rd changed, update the schedule
    if (prefs.getBool('delayed_3rd') != null &&
        prefs.getBool('delayed_3rd') != delayed3rd) {
      delayed3rd = prefs.getBool('delayed_3rd')!;
      initializeSchedulePage();
    }

    is24h = prefs.getBool('is_24h') ?? false;

    return Material(
      child: ScaffoldMessenger(
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: MyColors.background,
            appBar: scheduleAppBar(),
            body: Column(
              children: [
                // AddEventOverlay(),
                TableCalendar(
                  eventLoader: (day) => _getEventsForDay(day),
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
                  formatAnimationDuration: const Duration(milliseconds: 500),
                  formatAnimationCurve: Curves.decelerate,
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
                checkExistsDlorQ()
                    ? Container(
                        color: Colors.transparent,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            child: Container(
                              margin: const EdgeInsets.only(left: 20),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 1.1),
                                      color: MyApp.isDarkMode.value
                                          ? Colors.white24
                                          : Colors.black26,
                                      spreadRadius: 0.6)
                                ],
                                color: MyColors.background,
                              ),
                              child: Row(
                                children: buildTabs(),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
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
                            ? Border(
                                top: BorderSide(
                                    color: MyApp.isDarkMode.value
                                        ? Colors.white12
                                        : Colors.black12))
                            : null),
                    child: Column(
                      children: [
                        _eventDataSource
                                .getVisibleAppointments(
                                    _controller.displayDate!, '')
                                .isEmpty
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
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
                            // cellBorderColor: Colors.green,
                            //       // cellBorderColor: Colors.transparent,
                            viewHeaderHeight: 0,
                            headerHeight: 0,
                            showCurrentTimeIndicator: true,
                            selectionDecoration: const BoxDecoration(
                              color: Colors.transparent,
                              border: Border(),
                            ),
                            // onViewChanged: ,
                            onTap: (calendarTapDetails) {
                              setState(() {
                                tappedEvent =
                                    calendarTapDetails.appointments!.first;
                                alignment1 = editButtonsToggle
                                    ? const Alignment(-0.16, -2.7)
                                    : const Alignment(0, 0.8);
                                alignment2 = editButtonsToggle
                                    ? const Alignment(0.16, -2.7)
                                    : const Alignment(0, 0.8);
                                editButtonsToggle = !editButtonsToggle;
                              });
                            },
                            //onViewChanged: (details) {
                            //setState(() {
                            //  _selectedDay = _controller.displayDate ?? _selectedDay;
                            // });
                            //},
                            timeSlotViewSettings: TimeSlotViewSettings(
                                startHour: 7,
                                endHour: 19,
                                timeInterval: const Duration(hours: 1),
                                timeIntervalHeight: 65,
                                timeFormat: is24h ? "k:mm" : "h a",
                                timeRulerSize: 40,
                                timeTextStyle: TextStyle(
                                    color: MyColors.secondary,
                                    fontFamily: 'Outfit',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                nonWorkingDays: const <int>[
                                  DateTime.friday,
                                ]),
                            dataSource:
                                EventDataSource(events + quizzes + examEvents),
                            appointmentBuilder: appointmentBuilder,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

// ############################
// ####### PAGE WIDGETS #######
// ############################
  double monthButtonBottom = 0;
  double changeViewBtnScale = 1;
  AppBar scheduleAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: MyColors.primary,
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
            changeViewBtnScale =
                _calendarFormat == CalendarFormat.month ? -1 : 1;
          });
        },
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(5)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            // splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateColor.resolveWith(
                (states) => MyColors.primaryVariant.withOpacity(0.02))),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              Container(width: 20),
              Text(
                // DateFormat("MMMM").format(DateTime.now()),
                DateFormat("MMMM").format(_focusedDay),
                style: TextStyle(
                    color: Theme.of(context).appBarTheme.titleTextStyle!.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 30),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                transform: Matrix4.rotationX(changeViewBtnScale < 0 ? pi : 0),
                alignment: Alignment.center,
                transformAlignment: Alignment.center,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: MyApp.isDarkMode.value
                      ? MyColors.primary
                      : MyColors.secondary,
                  size: 25,
                ),
              ),
              // AnimatedScale(
              //   scale: changeViewBtnScale,
              //   curve: Curves.decelerate,
              //   duration: Duration(milliseconds: 600),
              //   child: const Icon(
              //     Icons.keyboard_arrow_down_rounded,
              //     color: MyColors.secondary,
              //     size: 25,
              //   ),
              // ),
            ],
          ),
        ),
      ),
      actions: [
        loadingExamSched
            ? const Center(
                child: SizedBox(
                    height: 25, width: 25, child: CircularProgressIndicator()),
              )
            : Container(),
        // IconButton(
        //     icon: const Icon(Icons.schedule_rounded,
        //         color: MyColors.secondary, size: 30),
        //     splashRadius: 15,
        //     tooltip: "Exam Schedule",
        //     onPressed: () {
        //       getExamSchedule();
        //     },
        //   ),
        const SizedBox(width: 10),
        IconButton(
          icon: SvgPicture.asset(
            "assets/images/today.svg",
            height: 26,
            color: MyColors.secondary,
          ),
          splashRadius: 15,
          tooltip: "Today",
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
    List<Appointment>? dayExams =
        EventDataSource(examEvents).getVisibleAppointments(date, '');
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
    if (dayExams.isNotEmpty) {
      icons.add(Text(
        "E",
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
      style: TextStyle(color: MyColors.background),
      child: Container(
        margin: isWeek
            ? const EdgeInsets.only(left: 2, right: 2)
            : const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: (day.year == DateTime.now().year &&
                    day.month == DateTime.now().month &&
                    day.day == DateTime.now().day)
                ? MyColors.primary
                : MyApp.isDarkMode.value
                    ? const Color.fromARGB(255, 163, 168, 188).withOpacity(0.6)
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
                // color: MyColors.background
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
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color:
                      // Color.fromARGB(255, 255, 149, 0)
                      MyColors.tertiary),
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
      style: TextStyle(
          color: MyApp.isDarkMode.value
              ? const Color.fromARGB(255, 176, 176, 176)
              : const Color.fromARGB(255, 95, 95, 95)),
      child: Container(
        margin: const EdgeInsets.all(0),
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

  checkExistsDlorQ() {
    List<dynamic>? dayQuizzes =
        _quizDataSource.getVisibleAppointments(_controller.displayDate!, '');
    List<dynamic>? dayDeadlines = _deadlineDataSource.getVisibleAppointments(
        _controller.displayDate!, '');
    return dayDeadlines.isNotEmpty || dayQuizzes.isNotEmpty;
  }

  buildTabs() {
    List<dynamic>? dayQuizzes =
        _quizDataSource.getVisibleAppointments(_controller.displayDate!, '');
    List<dynamic>? dayDeadlines = _deadlineDataSource.getVisibleAppointments(
        _controller.displayDate!, '');
    List<Widget> list = [];
    if (dayDeadlines.isNotEmpty) {
      list.add(
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
      );
    }
    if (dayQuizzes.isNotEmpty) {
      if (dayDeadlines.isNotEmpty) list.add(Container(width: 5));
      list.add(
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
      );
    }
    return list;
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
    return tabIndex == index
        ? MyColors.primary
        : MyApp.isDarkMode.value
            ? Colors.white12
            : Colors.black12;
  }

  getTabFrontColor(int index) {
    return tabIndex == index ? MyColors.background : MyColors.secondary;
  }

  Map<String, int> dayIndexMap = {
    'Thursday:': 4,
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

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
    events = [];
    print(schedule);
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
              recurrenceExceptionDates: [],
              location: eventLocation);
          events.add(event);
        }
      }
    }
    // print("Events $events");
    // _eventDataSource = EventDataSource(events);
  }

//   EventDataSource _getCalendarDataSource() {
//   List<Event> ramadanEvents = <Event>[];
//   for (int i = 0; i < events.length; i++) {
//     if (events[i].recurrence != null) {
//       RecurrenceProperties recurrenceProperties =
//           RecurrenceHelper.getRecurrenceProperties(events[i].recurrence!);
//       if (recurrenceProperties.recurrenceType == RecurrenceType.weekly &&
//           recurrenceProperties.weekDays.contains(DateTime.friday)) {
//         // change the time of the weekly meeting to 11 AM in March
//         if (events[i].startTime.month == 3) {
//           ramadanEvents.add(Appointment(
//             startTime: events[i].startTime.replace(hour: 11),
//             endTime: events[i].endTime.replace(hour: 12),
//             subject: events[i].subject,
//             recurrenceRule: events[i].recurrenceRule,
//           ));
//         } else {
//           ramadanEvents.add(events[i]);
//         }
//       } else if (recurrenceProperties.recurrenceType == RecurrenceType.weekly &&
//                  recurrenceProperties.weekDays.contains(DateTime.thursday)) {
//         // change the time of the project presentation to 3 PM in March
//         if (events[i].startTime.month == 3) {
//           ramadanEvents.add(Appointment(
//             startTime: events[i].startTime.replace(hour: 15),
//             endTime: events[i].endTime.replace(hour: 16),
//             subject: events[i].subject,
//             recurrenceRule: events[i].recurrenceRule,
//           ));
//         } else {
//           ramadanEvents.add(events[i]);
//         }
//       } else {
//         ramadanEvents.add(events[i]);
//       }
//     } else {
//       ramadanEvents.add(events[i]);
//     }
//   }

//   return AppointmentDataSource(ramadanEvents);
// }

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

  getColor() {
    var res = colors[colorIndex];
    colorIndex++;
    if (colorIndex >= colors.length) {
      colorIndex = 0;
    }
    return res;
  }

  Alignment alignment1 = const Alignment(0.0, 0.0);
  Alignment alignment2 = const Alignment(0.0, 0.0);
  bool editButtonsToggle = false;
  dynamic tappedEvent =
      Appointment(startTime: DateTime.now(), endTime: DateTime.now());

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final ScrollController scrollController = ScrollController();
    Event event = details.appointments.first;
    bool hasPassed = DateTime.now().isAfter(details.date
        .getDateOnly()
        .add(Duration(hours: event.end.hour, minutes: event.end.minute)));

    var dayExams =
        EventDataSource(examEvents).getVisibleAppointments(details.date, "");
    // bool isExamDay = dayExams.isNotEmpty;
    bool isExam = examEvents.contains(event);
    bool isQuiz = quizzes.contains(event) || examEvents.contains(event);
    EventDataSource dataSource = EventDataSource(events);
    // dataSource.events!.remove(details.events.first);

    // AnimatedAlign(
    //   curve: editButtonsToggle ? Curves.linear : Curves.decelerate,
    //   alignment: tappedEvent == event ? alignment1 : const Alignment(0, 0),
    //   duration: const Duration(milliseconds: 300),
    //   child: Container(
    //     width: 40,
    //     height: 40,
    //     decoration: const BoxDecoration(
    //         color: MyColors.primary,
    //         // borderRadius: BorderRadius.circular(50),
    //         shape: BoxShape.circle),
    //     child: IconButton(
    //       color: MyColors.background,
    //       icon: const Icon(Icons.edit)
    //       //  SvgPicture.asset(
    //       //   "assets/images/edit.svg",
    //       //   // height: 30,
    //       //   color: MyColors.background,
    //       // )
    //       ,
    //       onPressed: () async {
    //         var quiz = await goToAddQuiz();
    //         if (quiz != null) {
    //           print("Quiz: ${quiz.toString()}");
    //           quizzes.add(quiz);
    //           Requests.updateQuizzes(quizzes);

    //           setState(() {});
    //         }
    //       },
    //     ),
    //   ),
    // ),
    // AnimatedAlign(
    //   curve: editButtonsToggle ? Curves.linear : Curves.decelerate,
    //   alignment: tappedEvent == event ? alignment2 : const Alignment(0, 0),
    //   duration: const Duration(milliseconds: 300),
    //   child: Container(
    //     width: 40,
    //     height: 40,
    //     decoration: const BoxDecoration(
    //         color: MyColors.primary,
    //         // borderRadius: BorderRadius.circular(50),
    //         shape: BoxShape.circle),
    //     child: IconButton(
    //       color: MyColors.background,
    //       icon: const Icon(Icons.delete_outline_rounded),
    //       onPressed: () {},
    //     ),
    //   ),
    // ),
    return AnimatedOpacity(
      duration: const Duration(seconds: 2),
      opacity: hasPassed ? 0.6 : 1,
      child: Container(
        width: details.bounds.width,
        height: details.bounds.height,
        margin: const EdgeInsets.only(left: 7),
        // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: getColor(),
          borderRadius: BorderRadius.circular(13),
        ),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            crossAxisMargin: 2,
            interactive: true,
            radius: const Radius.circular(12),
            thickness: MaterialStateProperty.all(8),
            mainAxisMargin: 7,
            thumbColor:
                MaterialStateProperty.all(MyColors.secondary.withOpacity(0.3)),
            trackBorderColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Padding(
            // padding: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: FadingEdgeScrollView.fromSingleChildScrollView(
                gradientFractionOnEnd: 0.4,
                gradientFractionOnStart: 0.4,
                child: SingleChildScrollView(
                  controller: scrollController,
                  clipBehavior: Clip.antiAlias,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  // padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  child: Container(
                    constraints:
                        BoxConstraints(minHeight: details.bounds.height - 18),
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
                            // only wrap if it will overflow
                            SizedBox(
                              width: details.bounds.width - 20,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                runSpacing: 5,
                                children: [
                                  Text(event.description.toString()),
                                  FittedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        isExam
                                            ? Text(
                                                'Seat ${event.location.split(' in ')[0]}',
                                                textAlign: TextAlign.justify,
                                              )
                                            : Container(),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/location.svg",
                                              height: 11,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(isExam
                                                ? event.location
                                                    .split(' in ')[1]
                                                : event.location ?? "No Loc")
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 37,
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      overflow: TextOverflow.fade,
                                      courseMap[event.title
                                              .split(' ')
                                              .join('')] ??
                                          "No Course",
                                      maxLines: 2,
                                      // wrapWords: true,
                                      softWrap: true,
                                      wrapWords: true,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),

                                // FLAG ICON
                                isQuiz
                                    ? Icon(
                                        Icons.flag_rounded,
                                        color: MyColors.error,
                                        size: 17,
                                      )
                                    : const Text("")
                              ],
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                  "${DateFormat(is24h ? "k:mm" : 'h:mm a').format(event.start)} - ${DateFormat(is24h ? "k:mm" : 'h:mm a').format(event.end)}"),
                            ),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                            // Text("Room ${event.location.split(' in ')[0]}"),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // print(scrollController.position.maxScrollExtent);
    // // Add a text widget to the end of the list view if the scroll extent is greater than 0
    // if (scrollController.position.maxScrollExtent > 0) {
    //   children.add(
    //     Container(
    //       height: 20,
    //       width: 20,
    //       color: Colors.red,
    //     ),
    //   );
    // }
    // return Row(
    //   children: children,
    // );
  }

  List<Event> quizzes = Requests.getQuizzes();

  Widget quizBuilder() {
    List<dynamic>? dayQuizzes =
        _quizDataSource.getVisibleAppointments(_controller.displayDate!, '');
    return dayQuizzes.isEmpty
        ? Center(
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
                Appointment app = dayQuizzes[index];
                Event? event =
                    _quizDataSource.convertAppointmentToObject(null, app);
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // AnimatedAlign(
                    //   curve:
                    //       editButtonsToggle ? Curves.linear : Curves.decelerate,
                    //   alignment: tappedEvent == event
                    //       ? alignment2
                    //       : const Alignment(0, 0),
                    //   duration: const Duration(milliseconds: 300),
                    //   child: Container(
                    //     width: 40,
                    //     height: 40,
                    //     decoration: BoxDecoration(
                    //         color: MyColors.primary,
                    //         // borderRadius: BorderRadius.circular(50),
                    //         shape: BoxShape.circle),
                    //     child: IconButton(
                    //       color: MyColors.background,
                    //       icon: const Icon(Icons.delete_outline_rounded),
                    //       onPressed: () {},
                    //     ),
                    //   ),
                    // ),
                    // AnimatedAlign(
                    //   curve:
                    //       editButtonsToggle ? Curves.linear : Curves.decelerate,
                    //   alignment: tappedEvent == event
                    //       ? alignment1
                    //       : const Alignment(0, 0),
                    //   duration: const Duration(milliseconds: 300),
                    //   child: Container(
                    //     width: 40,
                    //     height: 40,
                    //     decoration: BoxDecoration(
                    //         color: MyColors.primary,
                    //         // borderRadius: BorderRadius.circular(50),
                    //         shape: BoxShape.circle),
                    //     child: IconButton(
                    //       color: MyColors.background,
                    //       icon: const Icon(Icons.edit),
                    //       onPressed: () {
                    //         //
                    //       },
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () async {
                        var editedEvent = await goToAddQuiz(eventToEdit: event);
                        if (editedEvent is Event) {
                          if (editedEvent == null) return;

                          quizzes.remove(event);
                          quizzes.add(editedEvent);
                        } else if (editedEvent is String &&
                            editedEvent == 'Delete') {
                          quizzes.remove(event);
                        }
                        _eventDataSource = EventDataSource(events + quizzes);
                        Requests.updateQuizzes(quizzes);

                        setState(() {});

                        setState(() {
                          tappedEvent = event;
                          alignment1 = editButtonsToggle
                              ? const Alignment(-0.16, -2.7)
                              : const Alignment(0, 0.8);
                          alignment2 = editButtonsToggle
                              ? const Alignment(0.16, -2.7)
                              : const Alignment(0, 0.8);
                          editButtonsToggle = !editButtonsToggle;
                        });
                      },
                      child: Container(
                        width: 190,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 9),
                        decoration: BoxDecoration(
                          color: MyColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DefaultTextStyle(
                            style: TextStyle(
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
                                    courseMap[
                                            event!.title.split(' ').join('')] ??
                                        "No Course Found",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Text("~ ${event.description.toString()} ~",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${DateFormat('h:mm a').format(event.start)} - ${DateFormat('h:mm a').format(event.end)}"),
                                      const SizedBox(width: 5),
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
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
  }

  List<Event> deadlines = [];

  Widget deadlineBuilder() {
    List<Appointment>? dayDeadlines = _deadlineDataSource
        .getVisibleAppointments(_controller.displayDate ?? DateTime.now(), '');
    return dayDeadlines.isEmpty
        ? Center(
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
                      style: TextStyle(
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
          duration: const Duration(milliseconds: 400),
          curve: Curves.decelerate,
          child: Icon(
            Icons.add_rounded,
            color: MyColors.primary,
            size: 35,
          ),
        ),
        buttonStyleData: ButtonStyleData(
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent)),
        isExpanded: true,
        value: dropdownValue,
        style: TextStyle(
            // decoration: TextDecoration.underline,
            color: MyApp.isDarkMode.value ? Colors.white70 : Colors.black54,
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.bold),
        // dropdownColor: MyColors.secondary,
        dropdownStyleData: DropdownStyleData(
            openInterval: const Interval(0, 1, curve: Curves.easeIn),
            offset: const Offset(0, 5),
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            )),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        onChanged: (String? value) async {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
          if (dropdownValue == "Quiz") {
            var quiz = await goToAddQuiz(initialDate: _selectedDay);
            if (quiz != null) {
              print("Quiz: ${quiz.toString()}");
              quizzes.add(quiz);
              _eventDataSource = EventDataSource(events + quizzes);
              Requests.updateQuizzes(quizzes);

              setState(() {});
            }
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
                  child: Text(
                    "Q",
                    style: TextStyle(color: MyColors.primary),
                  ),
                ),
                Container(width: 10),
                const Text("Add Quiz/Test")
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

  // Future<void> showAddEventOverlay() async {
  //   String result = await displayCupertino();
  //   print(result);
  //   if (result == "Quiz") {
  //     var quiz = await goToAddQuiz();
  //     print(quiz.toString());
  //     if (quiz != null) {
  //       quizzes.add(quiz);
  //     }
  //     setState(() {});
  //   }
  // }

  Future<dynamic> goToAddQuiz(
      {dynamic eventToEdit, DateTime? initialDate}) async {
    if (eventToEdit != null) {
      return await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddQuizPage(
                    courses: courses,
                    event: eventToEdit,
                  )));
    } else {
      return await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddQuizPage(
                    courses: courses,
                    initialDate: initialDate,
                  )));
    }
  }

  bool loadingExamSched = false;
  List<dynamic> examSchedule =
      jsonDecode(prefs.getString(SharedPrefs.examSched) ?? '[]');
  void getExamSchedule() {
    setState(() {
      loadingExamSched = true;
    });

    Requests.getExamSchedule().then((result) {
      setState(() {
        loadingExamSched = false;
      });
      if (result != null) {
        // print(result);
      }

      if (!result['success']) {
        showSnackBar(context, 'Could not get exam schedule.');
      } else {
        setState(() {
          examSchedule = result['exam_sched'];
        });
      }
      createExamEvents();
    });
  }

  List<Event> examEvents = [];
  void createExamEvents() {
    List<Event> exams = [];
    List<DateTime> dates = [];
    for (var exam in examSchedule) {
      // var examDay = exam['exam_day'][0];
      var examDate = exam['exam_date'][0];
      var startTime = exam['start_time'][0];
      var endTime = exam['end_time'][0];
      var hall = exam['hall'][0];
      var seat = exam['seat'];
      var courseName = exam['course_name'];

      DateFormat dateFormat = DateFormat('dd - MMMM - yyyy h:mm:ss a');

      var examDateTime = dateFormat.parse(examDate + ' ' + startTime);
      var examEndDateTime = dateFormat.parse(examDate + ' ' + endTime);
      // print('Start time: $examDateTime');
      var examEvent = Event(
          title: courseName,
          description: 'Midterm',
          location: '$seat in $hall',
          start: examDateTime,
          end: examEndDateTime,
          color: MyColors.primary,
          isAllDay: false);
      exams.add(examEvent);
      dates.add(examDateTime);
    }
    examEvents = exams;
    Requests.updateExams(exams);
    Future.delayed(Duration(milliseconds: 10), () => widget.notifyHomePage);
    setState(() {});

    for (Event event in events) {
      event.setRecurrenceExceptionDates(dates);
    }
  }
}

const List<String> list = ['Add Quiz/Test', 'Add Deadline'];
String? dropdownValue;
