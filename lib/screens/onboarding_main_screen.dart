import 'package:flutter/material.dart';
import 'package:kedul_app_main/app/business_model.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/screens/onboarding_business_creation_screen.dart';
import 'package:kedul_app_main/screens/onboarding_location_selection_screen.dart';
import 'package:kedul_app_main/widgets/error_placeholder.dart';
import 'package:kedul_app_main/widgets/loading_placeholder.dart';
import 'package:provider/provider.dart';

class OnboardingMainScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  @override
  _OnboardingMainScreenState createState() {
    return _OnboardingMainScreenState();
  }
}

class OnboardingMainScreenData {
  final List<Business> businesses;

  OnboardingMainScreenData({this.businesses});
}

class _OnboardingMainScreenState extends State<OnboardingMainScreen> {
  _OnboardingMainScreenState();

  Future<OnboardingMainScreenData> initData() async {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    BusinessModel businessModel =
        Provider.of<BusinessModel>(context, listen: false);

    User user = await authModel.getCurrentUser();
    List<Business> businesses =
        await businessModel.getBusinessesByUserID(user.id);

    return OnboardingMainScreenData(businesses: businesses);
  }

  @override
  Widget build(BuildContext context) {
    // Subscriptions
    Provider.of<AuthModel>(context);
    Provider.of<BusinessModel>(context);

    return Scaffold(
      body: FutureBuilder(
          future: initData(),
          builder: (BuildContext context,
              AsyncSnapshot<OnboardingMainScreenData> snapshot) {
            if (snapshot.hasError) {
              return ErrorPlaceholder(error: snapshot.error);
            }

            if (snapshot.hasData == false) {
              return LoadingPlaceholder();
            }

            if (snapshot.data.businesses.length == 0) {
              return OnboardingBusinessCreationScreen();
            }

            return OnboardingLocationSelectionScreen();
          }),
    );
  }
}
