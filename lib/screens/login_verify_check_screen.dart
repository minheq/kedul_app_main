import 'package:flutter/material.dart';
import 'package:kedul_app_main/data/auth_provider.dart';
import 'package:kedul_app_main/widgets/screen_container.dart';
import 'package:provider/provider.dart';

class LoginVerifyCheckScreen extends StatefulWidget {
  LoginVerifyCheckScreen(this.verificationID);

  final String verificationID;

  @override
  _LoginScreenVerifyCheckState createState() {
    return _LoginScreenVerifyCheckState(verificationID);
  }
}

class _LoginScreenVerifyCheckState extends State<LoginVerifyCheckScreen> {
  _LoginScreenVerifyCheckState(this.verificationID);

  final String verificationID;
  final formKey = GlobalKey<FormState>();

  Future<void> handleLoginVerifyCheck() async {
    AuthProvider authProvider = Provider.of(context, listen: false);

    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    try {
      String user = await authProvider.loginVerifyCheck(verificationID, '');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        body: Form(
            key: formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 96),
                  ],
                ))));
  }
}
