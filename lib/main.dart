import 'package:flutter/cupertino.dart';
import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_model.dart';
import 'package:kedul_app_main/auth/user_repository.dart';
import 'package:kedul_app_main/localization.dart';
import 'package:kedul_app_main/screens/login_verify_check_screen.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:kedul_app_main/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    APIClient apiClient = APIClient();
    FirebaseAnalytics analytics = FirebaseAnalytics();
    FirebaseAnalyticsObserver observer =
        FirebaseAnalyticsObserver(analytics: analytics);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(
          create: (context) {
            return UserModel(
                userRepository: UserRepository(apiClient: apiClient));
          },
        ),
        ChangeNotifierProxyProvider<UserModel, AuthModel>(
          create: (context) {
            return AuthModel(apiClient: apiClient);
          },
          update: (context, userModel, authModel) {
            authModel.setUserModel(userModel);

            return authModel;
          },
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MyAppLocalizationDelegate(),
        ],
        supportedLocales: [
          Locale('vi', ''),
          Locale('en', ''),
        ],
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              elevation: 0.0,
            ),
            primaryColor: Colors.white,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.teal[700],
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
              height: 48.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            textTheme: TextTheme(
              headline1:
                  TextStyle(fontSize: 31.25, fontWeight: FontWeight.bold),
              headline2: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              bodyText2: TextStyle(fontSize: 16.0),
              caption: TextStyle(fontSize: 12.8),
              button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
              overline: TextStyle(),
            ).apply(
                bodyColor: NamedColors.textDark,
                displayColor: NamedColors.textDark),
            // Cursor color for iOS
            cupertinoOverrideTheme: CupertinoThemeData(
              primaryColor: NamedColors.textDark,
            ),
            // Cursor color for Android, Fuschia
            cursorColor: NamedColors.textDark,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: Colors.white,
            inputDecorationTheme: InputDecorationTheme(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0))),
        navigatorObservers: <NavigatorObserver>[observer],
        initialRoute: LoginVerifyScreen.routeName,
        routes: {
          LoginVerifyScreen.routeName: (context) => LoginVerifyScreen(),
          LoginVerifyCheckScreen.routeName: (context) =>
              LoginVerifyCheckScreen(),
        },
      ),
    );
  }
}
