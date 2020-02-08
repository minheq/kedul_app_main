import 'package:flutter/material.dart';
import 'package:kedul_app_main/data/auth_provider.dart';
import 'package:kedul_app_main/data/phone_number.dart';
import 'package:kedul_app_main/widgets/button.dart';
import 'package:kedul_app_main/widgets/phone_number_form_field.dart';
import 'package:kedul_app_main/widgets/screen_container.dart';
import 'package:kedul_app_main/widgets/text.dart';
import 'package:provider/provider.dart';

class LoginVerifyScreen extends StatefulWidget {
  LoginVerifyScreen({Key key}) : super(key: key);

  @override
  _LoginScreenVerifyState createState() {
    return _LoginScreenVerifyState();
  }
}

class _LoginScreenVerifyState extends State<LoginVerifyScreen> {
  _LoginScreenVerifyState();

  final formKey = GlobalKey<FormState>();

  PhoneNumber phoneNumber = PhoneNumber(
    phoneNumber: '',
    countryCode: 'VN',
  );

  Future<void> handleLoginVerify() async {
    AuthProvider authProvider = Provider.of(context, listen: false);

    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    try {
      String verificationID = await authProvider.loginVerify(phoneNumber);
      print(verificationID);
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
                    Image(image: AssetImage('assets/logo.png'), width: 160),
                    SizedBox(height: 40),
                    CustomText(
                      'Enter your phone number to continue.',
                      color: TextColor.muted,
                    ),
                    SizedBox(height: 56),
                    PhoneNumberFormField(
                      initialValue: phoneNumber,
                      onSaved: (value) {
                        phoneNumber = PhoneNumber(
                          phoneNumber: value.phoneNumber,
                          countryCode: value.countryCode,
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    CustomText(
                      'By creating an account, you agree to our Terms of Service and Privacy Policy',
                      color: TextColor.muted,
                      size: TextSize.sm,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Button(
                          onPressed: handleLoginVerify,
                          title: 'Next',
                        )
                      ],
                    )
                  ],
                ))));
  }
}
