import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class CalendarMainScreen extends StatefulWidget {
  static const String routeName = '/calendar_main';

  @override
  _CalendarMainScreenState createState() {
    return _CalendarMainScreenState();
  }
}

class _CalendarMainScreenState extends State<CalendarMainScreen> {
  _CalendarMainScreenState();

  Future<void> handleLogOut() async {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);

    await authModel.logOut();

    Navigator.pushReplacementNamed(context, LoginVerifyScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 96),
                Text("Calendar Main Screen"),
                PrimaryButton(
                  onPressed: handleLogOut,
                  title: 'log out',
                )
              ],
            )));
  }
}
