import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kedul_app_main/firebase.dart';
import 'package:kedul_app_main/localization.dart';
import 'package:kedul_app_main/providers.dart';
import 'package:kedul_app_main/routes.dart';
import 'package:kedul_app_main/theme.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return MaterialApp(
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 0.0,
          ),
          primaryColor: theme.colors.background,
          buttonTheme: ButtonThemeData(
            buttonColor: theme.colors.buttonPrimary,
          ),
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 31.25, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            bodyText2: TextStyle(fontSize: 16.0),
            caption: TextStyle(fontSize: 12.8),
            button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
            overline: TextStyle(),
          ).apply(
              bodyColor: theme.colors.textDefault,
              displayColor: theme.colors.textDefault),
          // Cursor color for iOS
          cupertinoOverrideTheme: CupertinoThemeData(
            primaryColor: theme.colors.textDefault,
          ),
          // Cursor color for Android, Fuschia
          cursorColor: theme.colors.textDefault,
          fontFamily: theme.textStyles.fontFamily,
          scaffoldBackgroundColor: theme.colors.background,
          inputDecorationTheme: InputDecorationTheme(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0))),
      navigatorObservers: <NavigatorObserver>[observer],
      initialRoute: LoginVerifyScreen.routeName,
      routes: routes,
    );
  }
}
