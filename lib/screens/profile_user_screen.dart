import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:provider/provider.dart';

class ProfileUserScreen extends StatefulWidget {
  static const String routeName = '/profile_user_screen';

  @override
  _ProfileUserScreenState createState() {
    return _ProfileUserScreenState();
  }
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  _ProfileUserScreenState();

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
              SizedBox(height: 96),
              Text("Profile screen"),
              Text(currentUser.fullName),
            ],
          )),
    );
  }
}
