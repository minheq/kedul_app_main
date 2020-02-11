import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/otp_form_field.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class ScreenArguments {
  final String verificationID;

  ScreenArguments(this.verificationID);
}

class LoginVerifyCheckScreen extends StatefulWidget {
  static const String routeName = '/login_verify_check';

  @override
  _LoginVerifyCheckScreenState createState() {
    return _LoginVerifyCheckScreenState();
  }
}

class _LoginVerifyCheckScreenState extends State<LoginVerifyCheckScreen> {
  _LoginVerifyCheckScreenState();

  final formKey = GlobalKey<FormState>();

  Future<void> handleLoginVerifyCheck() async {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    AuthModel authModel = Provider.of(context, listen: false);

    if (args.verificationID == null) {
      return;
    }

    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    try {
      String accessToken =
          await authModel.loginVerifyCheck(args.verificationID, '');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
            key: formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verify your phone number",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text("We have sent verification code to phone number"),
                    SizedBox(height: 16),
                    FormFieldContainer(
                      labelText: "Verification code",
                      child: OTPFormField(),
                    )
                  ],
                ))),
        persistentFooterButtons: [
          PrimaryButton(onPressed: handleLoginVerifyCheck, title: "Next"),
        ]);
  }
}
