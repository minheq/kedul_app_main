import 'package:flutter/material.dart';
import 'package:kedul_app_main/screens/calendar_appointments_screen.dart';
import 'package:kedul_app_main/widgets/text_link.dart';

class CalendarMainScreen extends StatefulWidget {
  @override
  _CalendarMainScreenState createState() {
    return _CalendarMainScreenState();
  }
}

class _CalendarMainScreenState extends State<CalendarMainScreen> {
  _CalendarMainScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Calendar Main Screen"),
              TextLink("See all", CalendarAppointmentsScreen.routeName),
            ],
          )),
    );
  }
}
