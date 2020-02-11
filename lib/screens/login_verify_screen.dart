import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/data/phone_number.dart';
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

  PhoneNumber phoneNumber = PhoneNumber(
    phoneNumber: '',
    countryCode: 'VN',
  );

  Future<void> handleLoginVerify() async {
    AuthModel authModel = Provider.of(context, listen: false);

    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    try {
      String verificationID = await authModel.loginVerify(phoneNumber);

      Navigator.pushNamed(
        context,
        LoginVerifyCheckScreen.routeName,
        arguments: ScreenArguments(
          verificationID,
        ),
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
                    SizedBox(height: 96),
                    Image(image: AssetImage('assets/logo.png'), width: 160),
                    SizedBox(height: 40),
                    Text(
                      'Verify your phone number to continue.',
                    ),
                    SizedBox(height: 56),
                    FormFieldContainer(
                      labelText: "Phone number",
                      child: PhoneNumberFormField(
                        initialValue: phoneNumber,
                        onSaved: (value) {
                          phoneNumber = PhoneNumber(
                            phoneNumber: value.phoneNumber,
                            countryCode: value.countryCode,
                          );
                        },
                        onFieldSubmitted: (String value) {
                          handleLoginVerify();
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'By verifying phone number, you agree to our Terms of Service and Privacy Policy',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ))),
        persistentFooterButtons: [
          PrimaryButton(onPressed: handleLoginVerify, title: "Next"),
        ]);
  }
}
