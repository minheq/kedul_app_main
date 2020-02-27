import 'dart:async';

import 'package:kedul_app_main/app/business_model.dart';
import 'package:kedul_app_main/app/location_model.dart';
import 'package:kedul_app_main/screens/appointment_details_screen.dart';
import 'package:kedul_app_main/screens/calendar_appointments_screen.dart';
import 'package:kedul_app_main/screens/home_screen.dart';
import 'package:kedul_app_main/screens/onboarding_business_creation_screen.dart';
import 'package:kedul_app_main/screens/onboarding_location_creation_screen.dart';
import 'package:kedul_app_main/screens/onboarding_location_selection_screen.dart';
import 'package:kedul_app_main/screens/onboarding_main_screen.dart';
import 'package:kedul_app_main/screens/profile_account_settings_screen.dart';
import 'package:kedul_app_main/screens/profile_business_profile_update_screen.dart';
import 'package:kedul_app_main/screens/profile_business_settings_screen.dart';
import 'package:kedul_app_main/screens/profile_location_details_screen.dart';
import 'package:kedul_app_main/screens/profile_update_phone_number_check_screen.dart';
import 'package:kedul_app_main/screens/profile_update_phone_number_verify_screen.dart';
import 'package:kedul_app_main/screens/profile_user_profile_update_screen.dart';
import 'package:kedul_app_main/screens/profile_user_details_screen.dart';
import 'package:kedul_app_main/storage/storage_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/analytics/console_analytics_model.dart';
import 'package:kedul_app_main/analytics/firebase_analytics_model.dart';
import 'package:kedul_app_main/api/api_client.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/config.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/login_check_screen.dart';
import 'package:kedul_app_main/storage/secure_storage_model.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  AppConfig appConfig = AppConfig();
  AppEnvironment appEnvironment = AppEnvironment();
  SecureStorageModel secureStorageModel = SecureStorageModel();
  StorageModel storageModel = StorageModel();
  FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
  APIClient apiClient = APIClient(appConfig.apiBaseURL, secureStorageModel);
  AnalyticsModel analytics = appEnvironment.isProduction
      ? FirebaseAnalyticsModel(firebaseAnalytics)
      : ConsoleAnalyticsModel();
  AuthModel authModel =
      AuthModel(apiClient, secureStorageModel, storageModel, analytics);
  BusinessModel businessModel = BusinessModel(apiClient, analytics);
  LocationModel locationModel =
      LocationModel(apiClient, storageModel, analytics);

  analytics.log('app_init');

  User user = await authModel.getCurrentUser();

  String initialRoute;

  if (user == null) {
    initialRoute = LoginVerifyScreen.routeName;
  } else {
    Location currentLocation = await locationModel.getCurrentLocation();

    if (currentLocation == null) {
      initialRoute = OnboardingMainScreen.routeName;
    } else {
      initialRoute = HomeScreen.routeName;
    }
  }

  runZoned(() {
    runApp(MyApp(
      appConfig,
      appEnvironment,
      storageModel,
      secureStorageModel,
      firebaseAnalytics,
      apiClient,
      authModel,
      businessModel,
      locationModel,
      analytics,
      initialRoute,
    ));
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  MyApp(
    this.appConfig,
    this.appEnvironment,
    this.storageModel,
    this.secureStorageModel,
    this.firebaseAnalytics,
    this.apiClient,
    this.authModel,
    this.businessModel,
    this.locationModel,
    this.analytics,
    this.initialRoute,
  );

  final AppConfig appConfig;
  final AppEnvironment appEnvironment;
  final StorageModel storageModel;
  final SecureStorageModel secureStorageModel;
  final FirebaseAnalytics firebaseAnalytics;
  final APIClient apiClient;
  final AuthModel authModel;
  final BusinessModel businessModel;
  final LocationModel locationModel;
  final AnalyticsModel analytics;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = ThemeModel();
    FirebaseAnalyticsObserver observer =
        FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

    return MultiProvider(
      providers: [
        Provider<AnalyticsModel>(
          create: (context) {
            return analytics;
          },
        ),
        Provider<StorageModel>(
          create: (context) {
            return storageModel;
          },
        ),
        Provider<ThemeModel>(
          create: (context) {
            return theme;
          },
        ),
        ChangeNotifierProvider<AuthModel>(
          create: (context) {
            return authModel;
          },
        ),
        ChangeNotifierProvider<BusinessModel>(
          create: (context) {
            return businessModel;
          },
        ),
        ChangeNotifierProvider<LocationModel>(
          create: (context) {
            return locationModel;
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
        navigatorObservers: appEnvironment.isProduction ? [observer] : [],
        initialRoute: initialRoute,
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),

          // Auth
          LoginVerifyScreen.routeName: (context) => LoginVerifyScreen(),
          LoginCheckScreen.routeName: (context) => LoginCheckScreen(),

          // Onboarding
          OnboardingMainScreen.routeName: (context) => OnboardingMainScreen(),
          OnboardingBusinessCreationScreen.routeName: (context) =>
              OnboardingBusinessCreationScreen(),
          OnboardingLocationCreationScreen.routeName: (context) =>
              OnboardingLocationCreationScreen(),
          OnboardingLocationSelectionScreen.routeName: (context) =>
              OnboardingLocationSelectionScreen(),

          // Calendar
          CalendarAppointmentsScreen.routeName: (context) =>
              CalendarAppointmentsScreen(),

          // Appointment
          AppointmentDetailsScreen.routeName: (context) =>
              AppointmentDetailsScreen(),

          // Profile
          ProfileUserDetailsScreen.routeName: (context) =>
              ProfileUserDetailsScreen(),
          ProfileUserProfileUpdateScreen.routeName: (context) =>
              ProfileUserProfileUpdateScreen(),
          ProfileAccountSettingsScreen.routeName: (context) =>
              ProfileAccountSettingsScreen(),
          ProfileUpdatePhoneNumberVerifyScreen.routeName: (context) =>
              ProfileUpdatePhoneNumberVerifyScreen(),
          ProfileUpdatePhoneNumberCheckScreen.routeName: (context) =>
              ProfileUpdatePhoneNumberCheckScreen(),
          ProfileBusinessSettingsScreen.routeName: (context) =>
              ProfileBusinessSettingsScreen(),
          ProfileLocationDetailsScreen.routeName: (context) =>
              ProfileLocationDetailsScreen(),
          ProfileBusinessProfileUpdateScreen.routeName: (context) =>
              ProfileBusinessProfileUpdateScreen(),
        },
      ),
    );
  }
}
