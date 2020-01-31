import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme.dart';
import 'package:kedul_app_main/widgets/button.dart';
import 'package:kedul_app_main/widgets/heading.dart';
import 'package:kedul_app_main/widgets/phone_number_field.dart';
import 'package:kedul_app_main/widgets/spacing.dart';
import 'package:kedul_app_main/widgets/text.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.analytics, this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _LoginScreenState createState() {
    return _LoginScreenState(analytics, observer);
  }
}

class LoginStartResponse {
  final String state;

  LoginStartResponse({this.state});

  factory LoginStartResponse.fromJson(Map<String, dynamic> json) {
    return LoginStartResponse(
      state: json['state'],
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  _LoginScreenState(this.analytics, this.observer);
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  final _formKey = GlobalKey<FormState>();


  Future<String> handleLoginVerify() async {
    Map input = {'phoneNumber': '999123321', 'countryCode': 'VN'};

    var body = json.encode(input);

    try {
      await analytics.logEvent(
        name: 'press_login_verify',
      );
      final response = await http.post("http://localhost:4000/loginStart",
          headers: {"Content-Type": "application/json"}, body: body);

      final responseJson = json.decode(response.body);

      final data = LoginStartResponse.fromJson(responseJson);

      return data.state;
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: CustomColors.white,
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacing(96),
                    Image(image: AssetImage('assets/logo.png'), width: 160),
                    Spacing(40),
                    Heading(
                      'Welcome!',
                      size: HeadingSize.xl,
                    ),
                    Spacing(),
                    CustomText(
                      'Enter your phone number to continue.',
                      color: TextColor.muted,
                    ),
                    Spacing(56),
                    PhoneNumberField(),
                    Spacing(),
                    CustomText(
                      'By creating an account, you agree to our Terms of Service and Privacy Policy',
                      color: TextColor.muted,
                      size: TextSize.sm,
                    ),
                    Spacing(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Button(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            handleLoginVerify();
                          },
                          title: "Next",
                        )
                      ],
                    )
                  ],
                ))));
  }
}
