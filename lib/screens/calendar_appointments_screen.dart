import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/week_calendar.dart';

List<Staff> _staffList = [
  Staff(name: 'Mike'),
  Staff(name: 'Bob'),
  Staff(name: 'Aria'),
  Staff(name: 'Alexa'),
];

List<List<Appointment>> _appointmentList = [
  // Mike
  [
    Appointment(
        name: '1',
        startTime: DateTime(2020, 2, 22, 13, 40),
        endTime: DateTime(2020, 2, 22, 14, 00)),
    Appointment(
        name: '1',
        startTime: DateTime(2020, 2, 22, 13, 50),
        endTime: DateTime(2020, 2, 22, 14, 10)),
    Appointment(
        name: '1',
        startTime: DateTime(2020, 2, 22, 17, 0),
        endTime: DateTime(2020, 2, 22, 18, 0)),
    Appointment(
        name: '1',
        startTime: DateTime(2020, 2, 22, 23, 0),
        endTime: DateTime(2020, 2, 23, 1, 0))
  ],
  // Bob
  [],
  // Aria
  [],
  // Alexa
  [],
];

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
        children: <Widget>[
          Text("Appointments"),
          WeekCalendar(_staffList, _appointmentList)
        ],
      )),
    );
  }
}
