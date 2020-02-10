import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/theme.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:kedul_app_main/widgets/screen_container.dart';
import 'package:kedul_app_main/widgets/text.dart';
import 'package:kedul_app_main/widgets/text_form_field.dart';
import 'package:kedul_app_main/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class ScreenArguments {
  final String verificationID;

  ScreenArguments(this.verificationID);
}

class LoginVerifyCheckScreen extends StatefulWidget {
  static const String routeName = '/login_verify_check';

  @override
  _LoginScreenVerifyCheckState createState() {
    return _LoginScreenVerifyCheckState();
  }
}

class _LoginScreenVerifyCheckState extends State<LoginVerifyCheckScreen> {
  _LoginScreenVerifyCheckState();

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
    return ScreenContainer(
        topBar: TopBar(title: "LoginVerifyCheck"),
        body: Form(
            key: formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Login verify check"),
                    SizedBox(height: 16),
                    CustomTextFormField(),
                  ],
                ))),
        persistentFooterButtons: [
          PrimaryButton(
            onPressed: handleLoginVerifyCheck,
            title: 'Next',
          )
        ]);
  }
}
