import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/screens/login_verify_check_screen.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/phone_number_form_field.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LoginVerifyScreen extends StatefulWidget {
  static const String routeName = '/login_verify';

  @override
  _LoginVerifyScreenState createState() {
    return _LoginVerifyScreenState();
  }
}

class _LoginVerifyScreenState extends State<LoginVerifyScreen> {
  _LoginVerifyScreenState();

  final formKey = GlobalKey<FormState>();

  String phoneNumber = '';
  String countryCode = 'VN';

  Future<void> handleLoginVerify() async {
    AuthModel authModel = Provider.of(context, listen: false);

    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    try {
      String verificationID =
          await authModel.loginVerify(phoneNumber, countryCode);

      Navigator.pushNamed(
        context,
        LoginVerifyCheckScreen.routeName,
        arguments: ScreenArguments(verificationID, phoneNumber, countryCode),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 56),
                    Image(
                      image: AssetImage('assets/logo.png'),
                      width: 104,
                    ),
                    SizedBox(height: 80),
                    Text(
                      'Verify your phone number to continue.',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(height: 56),
                    FormFieldContainer(
                      labelText: "Phone number",
                      hintText:
                          "By verifying phone number, you agree to our Terms of Service and Privacy Policy",
                      child: PhoneNumberFormField(
                        initialValue: PhoneNumber(
                            phoneNumber: phoneNumber, countryCode: countryCode),
                        onSaved: (value) {
                          phoneNumber = value.phoneNumber;
                          countryCode = value.countryCode;
                        },
                        onFieldSubmitted: (String value) {
                          handleLoginVerify();
                        },
                      ),
                    ),
                  ],
                ))),
        persistentFooterButtons: [
          PrimaryButton(onPressed: handleLoginVerify, title: "Next"),
          SizedBox()
        ]);
  }
}
