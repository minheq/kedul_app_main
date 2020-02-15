import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';

class FirebaseAnalyticsModel implements AnalyticsModel {
  FirebaseAnalyticsModel(this.firebase);

  final FirebaseAnalytics firebase;

  Future<void> logEvent(
      {@required String name, Map<String, dynamic> parameters}) async {
    await firebase.logEvent(name: name, parameters: parameters);
  }

  Future<void> setCurrentScreen(
      {@required String screenName,
      String screenClassOverride = 'Flutter'}) async {
    await firebase.setCurrentScreen(
        screenName: screenName, screenClassOverride: screenClassOverride);
  }

  Future<void> recordError(dynamic exception, StackTrace stack,
      {dynamic context}) async {
    await Crashlytics.instance.recordError(exception, stack, context: context);
  }

  Future<void> setUserIdentifier(String identifier) async {
    await Crashlytics.instance.setUserIdentifier(identifier);
  }

  void setString(String key, String value) {
    Crashlytics.instance.setString(key, value);
  }

  void log(String message) {
    Crashlytics.instance.log(message);
  }
}
