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
}
