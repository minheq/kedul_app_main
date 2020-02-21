import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/week_calendar.dart';

class CalendarAppointmentsScreen extends StatefulWidget {
  static const String routeName = '/calendar_appointments';

  @override
  _CalendarAppointmentsScreenState createState() {
    return _CalendarAppointmentsScreenState();
  }
}

class _CalendarAppointmentsScreenState
    extends State<CalendarAppointmentsScreen> {
  _CalendarAppointmentsScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BodyPadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text("Appointments"), WeekCalendar()],
      )),
    );
  }
}
