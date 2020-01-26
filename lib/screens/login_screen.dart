import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_salon/theme.dart';
import 'package:app_salon/widgets/button.dart';
import 'package:app_salon/widgets/heading.dart';
import 'package:app_salon/widgets/phone_number_field.dart';
import 'package:app_salon/widgets/spacing.dart';
import 'package:app_salon/widgets/text.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
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
  final _formKey = GlobalKey<FormState>();

  Future<String> handleLoginStart() async {
    Map input = {'phoneNumber': '999123321', 'countryCode': 'VN'};

    var body = json.encode(input);

    try {
      final response = await http.post("http://localhost:4000/loginStart",
          headers: {"Content-Type": "application/json"}, body: body);

      // if (response.statusCode != 200) {
      //   return "";
      // }

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
                            handleLoginStart();
                          },
                          title: "Next",
                        )
                      ],
                    )
                  ],
                ))));
  }
}
