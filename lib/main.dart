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
        theme: ThemeData(),
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
