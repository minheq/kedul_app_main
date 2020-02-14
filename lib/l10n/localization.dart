import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kedul_app_main/l10n/messages_all.dart';

class MyAppLocalization {
  MyAppLocalization(this.localeName);

  static Future<MyAppLocalization> load(Locale locale) async {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    await initializeMessages(localeName);

    return MyAppLocalization(localeName);
  }

  static MyAppLocalization of(BuildContext context) {
    return Localizations.of<MyAppLocalization>(context, MyAppLocalization);
  }

  final String localeName;

  String get commonNext {
    return Intl.message(
      'Hello World',
      name: 'commonNext',
      desc: 'Title for the Demo application',
      locale: localeName,
    );
  }

  String get commonPhoneNumber {
    return Intl.message(
      'Phone number',
      name: 'commonPhoneNumber',
      locale: localeName,
    );
  }

  String get loginVerifyScreenTitle {
    return Intl.message(
      'Verify your phone number to continue.',
      name: 'loginVerifyScreenTitle',
      locale: localeName,
    );
  }

  String get loginVerifyScreenAcceptTerms {
    return Intl.message(
      'By verifying phone number, you agree to our Terms of Service and Privacy Policy',
      name: 'loginVerifyScreenAcceptTerms',
      locale: localeName,
    );
  }
}

class MyAppLocalizationDelegate
    extends LocalizationsDelegate<MyAppLocalization> {
  const MyAppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<MyAppLocalization> load(Locale locale) =>
      MyAppLocalization.load(Locale('vi', ''));

  @override
  bool shouldReload(MyAppLocalizationDelegate old) => false;
}
