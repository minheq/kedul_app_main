import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  static const String routeName = '/appointment_details';

  @override
  _AppointmentDetailsScreenState createState() {
    return _AppointmentDetailsScreenState();
  }
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  _AppointmentDetailsScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BodyPadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text("Appointment")],
      )),
    );
  }
}
