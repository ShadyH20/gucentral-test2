import "dart:async";
import "dart:convert";
import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gucentral/widgets/MenuWidget.dart";
import "package:gucentral/widgets/MyColors.dart";
import 'package:intl/intl.dart';
import "package:table_calendar/table_calendar.dart";

// import 'package:navigation_drawer_animation/widet/menu_widget'

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String formattedTime = DateFormat('kk:mm::ss').format(DateTime.now());
  String hour = DateFormat('a').format(DateTime.now());

  late Timer _timer;
  DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  //   CalendarFormat _calendarFormat = CalendarFormat.month;
  // DateTime _focusedDay = DateTime.now();
  // DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // _timer =
    // Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());
  }

  void _update() {
    setState(() {
      formattedTime = DateFormat('kk:mm:ss').format(DateTime.now());
      hour = DateFormat('a').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
            // padding: EdgeInsets.symmetric(horizontal: 20.0),
            icon: const Icon(
              Icons.add,
              color: MyColors.primary,
              size: 35,
            ),
            onPressed: () {},
          ),
          Container(
            width: 15,
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(3030, 3, 14),
              focusedDay: _selectedDay,
              calendarFormat: _calendarFormat,
              daysOfWeekVisible: false,
              rowHeight: 100,
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) =>
                    defaultDayBuilder(context, date, _),
                selectedBuilder: (context, day, focusedDay) =>
                    selectedDayBuilder(context, day, focusedDay),
                todayBuilder: (context, day, focusedDay) =>
                    todayBuilder(context, day, focusedDay),
              ),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontSize: 16),
                weekendStyle: TextStyle(fontSize: 16),
              ),
              headerStyle: const HeaderStyle(
                titleTextStyle:
                    TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                titleCentered: true,
                formatButtonVisible: false,
              ),
              availableCalendarFormats: const {
                CalendarFormat.week: 'Week',
              },
              startingDayOfWeek: StartingDayOfWeek.saturday,
              // rangeEndDay: DateTime.now().add(Duration(days: 2)),
              // rangeStartDay: DateTime.now().subtract(Duration(days: 2)),
            ),
          ],
        ),
      ),
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
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            color: MyColors.primary, borderRadius: BorderRadius.circular(7)),
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
            Text(DateFormat('EEE').format(focusedDay).toLowerCase()),
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
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
                color: MyColors.background,
                borderRadius: BorderRadius.circular(7)),
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Expanded(
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
                  Text(DateFormat('EEE').format(day).toLowerCase()),
                ],
              ),
            ),
          ),
          const Positioned(
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
          ),
        ],
      ),
    );
  }

  defaultDayBuilder(BuildContext context, DateTime date, DateTime dateTime) {
    return DefaultTextStyle(
      style: const TextStyle(color: Color.fromARGB(255, 95, 95, 95)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
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
            Text(DateFormat('EEE').format(date).toLowerCase()),
          ],
        ),
      ),
    );
  }
}
