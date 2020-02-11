import 'package:flutter/material.dart';

class CalendarMainScreen extends StatefulWidget {
  static const String routeName = '/login_verify_check';

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
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 96),
                Text("Calendar Main Screen")
              ],
            )));
  }
}
