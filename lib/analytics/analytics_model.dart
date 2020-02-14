import 'package:flutter/material.dart';

abstract class AnalyticsModel {
  Future<void> logEvent(
      {@required String name, Map<String, dynamic> parameters});
  Future<void> setCurrentScreen(
      {@required String screenName, String screenClassOverride = 'Flutter'});
}
