import 'package:flutter/material.dart';

abstract class AnalyticsModel {
  Future<void> logEvent(
      {@required String name, Map<String, dynamic> parameters});
  Future<void> setCurrentScreen(
      {@required String screenName, String screenClassOverride = 'Flutter'});

  Future<void> recordError(dynamic exception, StackTrace stack,
      {dynamic context});

  Future<void> setUserIdentifier(String id);

  void setString(String key, String value);

  void log(String message);
}
