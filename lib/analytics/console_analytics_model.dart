import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';

class ConsoleAnalyticsModel implements AnalyticsModel {
  Future<void> logEvent(
      {@required String name, Map<String, dynamic> parameters}) async {
    print(name);
  }

  Future<void> setCurrentScreen(
      {@required String screenName,
      String screenClassOverride = 'Flutter'}) async {
    print(screenName);
  }

  Future<void> recordError(dynamic exception, StackTrace stack,
      {dynamic context}) async {
    print(exception);
    print(stack);
    print(context);
  }

  Future<void> setUserIdentifier(String id) async {
    print('setUserID' + id);
  }

  void setString(String key, String value) async {
    print('setString key=' + key + ' value: ' + value);
  }

  void log(String message) async {
    print(message);
  }
}
