import 'package:flutter/material.dart';
import 'package:kedul_app_main/app/business_model.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/screens/calendar_main_screen.dart';
import 'package:kedul_app_main/screens/onboarding_business_creation_screen.dart';
import 'package:provider/provider.dart';

class OnboardingLocationSelectionScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  @override
  OnboardingLocationSelectionScreenState createState() {
    return OnboardingLocationSelectionScreenState();
  }
}

class OnboardingLocationSelectionScreenData {
  final List<Business> businesses;

  OnboardingLocationSelectionScreenData({this.businesses});
}

class OnboardingLocationSelectionScreenState
    extends State<OnboardingLocationSelectionScreen> {
  OnboardingLocationSelectionScreenState();

  Future<OnboardingLocationSelectionScreenData> initData() async {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    BusinessModel businessModel =
        Provider.of<BusinessModel>(context, listen: false);

    User user = await authModel.getCurrentUser();
    List<Business> businesses =
        await businessModel.getBusinessesByUserID(user.id);

    return OnboardingLocationSelectionScreenData(businesses: businesses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: initData(),
          builder: (BuildContext context,
              AsyncSnapshot<OnboardingLocationSelectionScreenData> snapshot) {
            if (snapshot.hasError) {
              return CalendarMainScreen();
            }

            if (snapshot.hasData == false) {
              return CalendarMainScreen();
            }

            if (snapshot.data.businesses.length == 0) {
              return OnboardingBusinessCreationScreen();
            }

            List<Widget> businessWidgetList = [];

            for (Business business in snapshot.data.businesses) {
              businessWidgetList.add(Text(business.name));
            }

            return Column(
              children: businessWidgetList,
            );
          }),
    );
  }
}
