import 'package:flutter/material.dart';
import 'package:kedul_app_main/screens/calendar_appointments_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:provider/provider.dart';

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
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: BodyPadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Calendar Main Screen"),
          InkWell(
              child: Text(
                "See all",
                style: theme.textStyles.link,
              ),
              onTap: () {
                Navigator.pushNamed(
                    context, CalendarAppointmentsScreen.routeName);
              }),
        ],
      )),
    );
  }
}
