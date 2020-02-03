import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/button.dart';
import 'package:kedul_app_main/widgets/phone_number_form_field.dart';
import 'package:kedul_app_main/widgets/screen.dart';
import 'package:kedul_app_main/widgets/text.dart';

class LoginVerifyScreen extends StatefulWidget {
  LoginVerifyScreen({Key key, this.analytics}) : super(key: key);

  final FirebaseAnalytics analytics;
  @override
  _LoginScreenState createState() {
    return _LoginScreenState(analytics);
  }
}

class LoginVerifyRequest {
  LoginVerifyRequest();

  String phoneNumber;
  String countryCode;

  String toJson() {
    var mapData = new Map();

    mapData['phoneNumber'] = phoneNumber;
    mapData['countryCode'] = countryCode;

    String data = json.encode(mapData);
    return data;
  }
}

class LoginVerifyResponse {
  final String clientState;

  LoginVerifyResponse({this.clientState});

  factory LoginVerifyResponse.fromJson(Map<String, dynamic> json) {
    return LoginVerifyResponse(
      clientState: json['clientState'],
    );
  }
}

class _LoginScreenState extends State<LoginVerifyScreen> {
  _LoginScreenState(this.analytics);
  final FirebaseAnalytics analytics;
  final formKey = GlobalKey<FormState>();

  LoginVerifyRequest loginVerifyRequest = LoginVerifyRequest();

  Future<String> handleLoginVerify() async {
    if (!formKey.currentState.validate()) {
      return '';
    }

    formKey.currentState.save();

    try {
      String body = loginVerifyRequest.toJson();

      final response = await http.post('http://localhost:4000/login_verify',
          headers: {'Content-Type': 'application/json'}, body: body);

      final data = LoginVerifyResponse.fromJson(json.decode(response.body));

      return data.clientState;
    } catch (e) {
      print(e);
      return '';
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
                      initialValue: PhoneNumber(
                        phoneNumber: '',
                        countryCode: 'VN',
                      ),
                      onSaved: (value) {
                        loginVerifyRequest.phoneNumber = value.phoneNumber;
                        loginVerifyRequest.countryCode = value.countryCode;
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
