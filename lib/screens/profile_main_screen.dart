import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class ProfileMainScreen extends StatefulWidget {
  @override
  _ProfileMainScreenState createState() {
    return _ProfileMainScreenState();
  }
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {
  _ProfileMainScreenState();

  Future<void> handleLogOut() async {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);

    await authModel.logOut();

    Navigator.pushReplacementNamed(context, LoginVerifyScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    AuthModel authModel = Provider.of<AuthModel>(context);
    User currentUser = authModel.currentUser;

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 96),
              Text("Profile screen"),
              Text(currentUser.fullName),
              PrimaryButton(
                onPressed: handleLogOut,
                title: 'log out',
              )
            ],
          )),
    );
  }
}
