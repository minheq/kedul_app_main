import 'package:flutter/material.dart';
import 'package:kedul_app_main/screens/login_verify_check_screen.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  LoginVerifyScreen.routeName: (context) => LoginVerifyScreen(),
  LoginVerifyCheckScreen.routeName: (context) => LoginVerifyCheckScreen(),
};
