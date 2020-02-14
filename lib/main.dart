import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_model.dart';
import 'package:kedul_app_main/auth/user_repository.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/login_verify_check_screen.dart';
import 'package:provider/provider.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';

void main() {
  runApp(MyApp());
}

APIClient apiClient = APIClient();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AnalyticsModel>(
          create: (context) {
            return AnalyticsModel();
          },
        ),
        Provider<ThemeModel>(
          create: (context) {
            return ThemeModel();
          },
        ),
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
        )
      ],
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);
    AnalyticsModel analytics = Provider.of<AnalyticsModel>(context);

    FirebaseAnalyticsObserver observer =
        FirebaseAnalyticsObserver(analytics: analytics);

    return MaterialApp(
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
          primaryColor: theme.colors.background,
          buttonTheme: ButtonThemeData(
            buttonColor: theme.colors.buttonPrimary,
          ),
          textTheme: TextTheme(
            headline1: theme.textStyles.headline1,
            headline2: theme.textStyles.headline2,
            headline3: theme.textStyles.headline3,
            bodyText2: theme.textStyles.bodyText2,
            caption: theme.textStyles.caption,
            button: theme.textStyles.button,
            overline: theme.textStyles.overline,
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
          inputDecorationTheme: theme.utilityStyles.inputDecoration),
      navigatorObservers: <NavigatorObserver>[observer],
      initialRoute: LoginVerifyScreen.routeName,
      routes: {
        LoginVerifyScreen.routeName: (context) => LoginVerifyScreen(),
        LoginVerifyCheckScreen.routeName: (context) => LoginVerifyCheckScreen(),
      },
    );
  }
}
