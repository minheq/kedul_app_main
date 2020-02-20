import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:provider/provider.dart';

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
    AuthModel authModel = Provider.of<AuthModel>(context);
    User currentUser = authModel.currentUser;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Calendar Appointment"),
              Text(currentUser.fullName),
            ],
          )),
    );
  }
}
