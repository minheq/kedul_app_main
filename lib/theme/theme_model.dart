import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeModel {
  final ThemeColors colors = ThemeColors();
  final ThemeUtilityStyles utilityStyles = ThemeUtilityStyles();
  final ThemeTextStyles textStyles = ThemeTextStyles();
}

class ThemeColors {
  final Color buttonPrimary = MyAppPalette.green700;

  final Color textDefault = MyAppPalette.grey900;
  final Color textMuted = MyAppPalette.grey700;
  final Color textPrimary = MyAppPalette.green800;
  final Color textError = MyAppPalette.red700;
  final Color textLink = MyAppPalette.green900;
  final Color textButtonPrimary = MyAppPalette.white;

  final Color border = MyAppPalette.grey700;
  final Color content = MyAppPalette.white;
  final Color background = MyAppPalette.white;

  final Color boxPrimaryLight = MyAppPalette.green100;

  final BoxShadow shadow = BoxShadow(
      color: MyAppPalette.grey700.withOpacity(0.2),
      offset: Offset(0, 2),
      blurRadius: 8.0);
}

class ThemeUtilityStyles {
  final double controlHeight = 56.0;

  final double borderRadius = 16.0;

  final InputDecorationTheme inputDecoration = InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0));
}

class ThemeTextStyles {
  final String fontFamily = 'Roboto';

  final TextStyle headline1 =
      TextStyle(fontSize: 31.25, fontWeight: FontWeight.bold);
  final TextStyle headline2 =
      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);
  final TextStyle headline3 =
      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  final TextStyle bodyText1 = TextStyle(fontSize: 20.0);
  final TextStyle bodyText2 = TextStyle(fontSize: 16.0);
  final TextStyle caption = TextStyle(fontSize: 12.8);
  final TextStyle button =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  final TextStyle overline = TextStyle(fontSize: 12.8);
  final TextStyle link =
      TextStyle(fontSize: 16.0, color: MyAppPalette.green900);
}

class MyAppPalette {
  MyAppPalette._();

  static const Color green50 = Color(0xffEFFCF6);
  static const Color green100 = Color(0xffC6F7E2);
  static const Color green200 = Color(0xff8EEDC7);
  static const Color green300 = Color(0xff65D6AD);
  static const Color green400 = Color(0xff3EBD93);
  static const Color green500 = Color(0xff27AB83);
  static const Color green600 = Color(0xff199473);
  static const Color green700 = Color(0xff14866E);
  static const Color green800 = Color(0xff0C6B58);
  static const Color green900 = Color(0xff014D40);

  static const Color grey50 = Color(0xffFAFAFA);
  static const Color grey100 = Color(0xffF5F5F5);
  static const Color grey200 = Color(0xffEEEEEE);
  static const Color grey300 = Color(0xffE0E0E0);
  static const Color grey400 = Color(0xffBDBDBD);
  static const Color grey500 = Color(0xff9E9E9E);
  static const Color grey600 = Color(0xff757575);
  static const Color grey700 = Color(0xff616161);
  static const Color grey800 = Color(0xff424242);
  static const Color grey900 = Color(0xff212121);

  static const Color blue50 = Color(0xffDCEEFB);
  static const Color blue100 = Color(0xffB6E0FE);
  static const Color blue200 = Color(0xff84C5F4);
  static const Color blue300 = Color(0xff62B0E8);
  static const Color blue400 = Color(0xff4098D7);
  static const Color blue500 = Color(0xff2680C2);
  static const Color blue600 = Color(0xff186FAF);
  static const Color blue700 = Color(0xff0F609B);
  static const Color blue800 = Color(0xff0A558C);
  static const Color blue900 = Color(0xff003E6B);

  static const Color purple50 = Color(0xffEAE2F8);
  static const Color purple100 = Color(0xffCFBCF2);
  static const Color purple200 = Color(0xffA081D9);
  static const Color purple300 = Color(0xff8662C7);
  static const Color purple400 = Color(0xff724BB7);
  static const Color purple500 = Color(0xff653CAD);
  static const Color purple600 = Color(0xff51279B);
  static const Color purple700 = Color(0xff421987);
  static const Color purple800 = Color(0xff34126F);
  static const Color purple900 = Color(0xff240754);

  static const Color red50 = Color(0xffFFEEEE);
  static const Color red100 = Color(0xffFACDCD);
  static const Color red200 = Color(0xffF29B9B);
  static const Color red300 = Color(0xffE66A6A);
  static const Color red400 = Color(0xffD64545);
  static const Color red500 = Color(0xffBA2525);
  static const Color red600 = Color(0xffA61B1B);
  static const Color red700 = Color(0xff911111);
  static const Color red800 = Color(0xff780A0A);
  static const Color red900 = Color(0xff610404);

  static const Color yellow50 = Color(0xffFFFAEB);
  static const Color yellow100 = Color(0xffFCEFC7);
  static const Color yellow200 = Color(0xffF8E3A3);
  static const Color yellow300 = Color(0xffF9DA8B);
  static const Color yellow400 = Color(0xffF7D070);
  static const Color yellow500 = Color(0xffE9B949);
  static const Color yellow600 = Color(0xffC99A2E);
  static const Color yellow700 = Color(0xffA27C1A);
  static const Color yellow800 = Color(0xff7C5E10);
  static const Color yellow900 = Color(0xff513C06);

  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);

  static const Color transparent = Color(0x00000000);
}
