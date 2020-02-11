import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_model.dart';
import 'package:kedul_app_main/auth/user_repository.dart';
import 'package:kedul_app_main/screens/login_verify_check_screen.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart';

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
            textSelectionColor: Colors.red,
            textSelectionHandleColor: Colors.red,
            cursorColor: Colors.red,
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 16.0),
              headline2: TextStyle(fontSize: 16.0),
              headline3: TextStyle(fontSize: 16.0),
              headline4: TextStyle(fontSize: 16.0),
              headline5: TextStyle(fontSize: 16.0),
              headline6: TextStyle(fontSize: 16.0),
              subtitle1: TextStyle(fontSize: 16.0),
              subtitle2: TextStyle(fontSize: 16.0),
              bodyText1: TextStyle(fontSize: 13.0),
              bodyText2: TextStyle(fontSize: 16.0), // Default
              caption: TextStyle(fontSize: 16.0),
              button: TextStyle(fontSize: 16.0),
              overline: TextStyle(fontSize: 16.0),
            ),
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
