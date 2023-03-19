import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gucentral/widgets/Requests.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getEventData(index).start;
  }

  @override
  DateTime getEndTime(int index) {
    return _getEventData(index).end;
  }

  @override
  String getSubject(int index) {
    return _getEventData(index).title;
  }

  @override
  String? getNotes(int index) {
    return _getEventData(index).description;
  }

  @override
  Color getColor(int index) {
    return _getEventData(index).color;
  }

  @override
  bool isAllDay(int index) {
    return _getEventData(index).isAllDay;
  }

  @override
  String? getRecurrenceRule(int index) {
    return _getEventData(index).recurrence;
  }

  @override
  String? getLocation(int index) {
    return _getEventData(index).location;
  }

  Event _getEventData(int index) {
    final dynamic event = appointments![index];
    late final Event eventData;
    if (event is Event) {
      print("IM EVENT");
      eventData = event;
    } else {
      print("IM NOT EVENT");
    }

    return eventData;
  }
}
