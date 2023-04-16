import 'dart:convert';
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
  List<Appointment> getVisibleAppointments(
      DateTime startDate, String calendarTimeZone,
      [DateTime? endDate]) {
    // TODO: implement getVisibleAppointments
    return super.getVisibleAppointments(startDate, calendarTimeZone, endDate);
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
    return jsonEncode({
      'description': _getEventData(index).description,
      'slot': _getEventData(index).slot,
      'group': _getEventData(index).group,
    });
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
  List<DateTime>? getRecurrenceExceptionDates(int index) {
    return _getEventData(index).recurrenceExceptionDates;
  }

  @override
  String? getLocation(int index) {
    return _getEventData(index).location;
  }

  Event _getEventData(int index) {
    final dynamic event = appointments![index];
    late final Event eventData;
    if (event is Event) {
      eventData = event;
    }

    return eventData;
  }

  @override
  Event? convertAppointmentToObject(
      Object? customData, Appointment appointment) {
    dynamic notes = jsonDecode(appointment.notes ?? "");
    return Event(
      title: appointment.subject,
      description: notes['description'] ?? "",
      start: appointment.startTime,
      end: appointment.endTime,
      color: appointment.color,
      isAllDay: appointment.isAllDay,
      location: appointment.location ?? "",
      slot: notes['slot'] ?? "0",
      group: notes['group'] ?? "",
    );
  }
}
