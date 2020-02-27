import 'package:flutter/material.dart';
import 'package:kedul_app_main/app/business_model.dart';
import 'package:kedul_app_main/app/location_model.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';
import 'package:kedul_app_main/screens/onboarding_location_selection_screen.dart';
import 'package:kedul_app_main/screens/profile_account_settings_screen.dart';
import 'package:kedul_app_main/screens/profile_business_settings_screen.dart';
import 'package:kedul_app_main/screens/profile_location_details_screen.dart';
import 'package:kedul_app_main/screens/profile_user_details_screen.dart';
import 'package:kedul_app_main/screens/profile_user_profile_update_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/error_placeholder.dart';
import 'package:kedul_app_main/widgets/link_button.dart';
import 'package:kedul_app_main/widgets/list_item.dart';
import 'package:kedul_app_main/widgets/loading_placeholder.dart';
import 'package:kedul_app_main/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

class ProfileMainScreen extends StatefulWidget {
  @override
  _ProfileMainScreenState createState() {
    return _ProfileMainScreenState();
  }
}

class _ProfileMainScreenData {
  final Business business;
  final Location currentLocation;
  final User user;

  _ProfileMainScreenData({this.business, this.currentLocation, this.user});
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {
  _ProfileMainScreenState();

  Future<_ProfileMainScreenData> _initData() async {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    LocationModel locationModel =
        Provider.of<LocationModel>(context, listen: false);
    BusinessModel businessModel =
        Provider.of<BusinessModel>(context, listen: false);

    User user = await authModel.getCurrentUser();
    Location currentLocation = await locationModel.getCurrentLocation();
    Business business =
        await businessModel.getBusinessByID(currentLocation.businessID);

    return _ProfileMainScreenData(
        user: user, currentLocation: currentLocation, business: business);
  }

  Future<void> handleLogOut() async {
    AuthModel auth = Provider.of<AuthModel>(context, listen: false);

    await auth.logOut();

    Navigator.pushReplacementNamed(context, LoginVerifyScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    MyAppLocalization l10n = MyAppLocalization.of(context);
    ThemeModel theme = Provider.of<ThemeModel>(context);
    // Subscriptions
    Provider.of<AuthModel>(context);
    Provider.of<BusinessModel>(context);
    Provider.of<LocationModel>(context);

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _initData(),
          builder: (context, AsyncSnapshot<_ProfileMainScreenData> snapshot) {
            if (snapshot.hasError) {
              return ErrorPlaceholder(error: snapshot.error);
            }

            if (snapshot.hasData == false) {
              return LoadingPlaceholder();
            }

            Location currentLocation = snapshot.data.currentLocation;
            Business business = snapshot.data.business;
            User user = snapshot.data.user;

            return BodyPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListItem(
                  image: ProfilePicture(
                    image: null,
                    name: user.fullName,
                    size: 48,
                  ),
                  title: user.fullName == "" ? "Setup profile" : user.fullName,
                  onTap: () {
                    if (user.fullName == "") {
                      Navigator.pushNamed(
                          context, ProfileUserProfileUpdateScreen.routeName);

                      return;
                    }
                    Navigator.pushNamed(
                        context, ProfileUserDetailsScreen.routeName);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListItem(
                        image: ProfilePicture(
                          image: null,
                          name: currentLocation.name,
                          size: 48,
                        ),
                        title: currentLocation.name,
                        onTap: () {
                          Navigator.pushNamed(
                              context, ProfileLocationDetailsScreen.routeName);
                        },
                      ),
                    ),
                    LinkButton(
                        title: "Change",
                        onPressed: () {
                          Navigator.pushNamed(context,
                              OnboardingLocationSelectionScreen.routeName);
                        })
                  ],
                ),
                ListItem(
                  title: l10n.profileAccountSettingsTitle,
                  onTap: () {
                    Navigator.pushNamed(
                        context, ProfileAccountSettingsScreen.routeName);
                  },
                ),
                if (business.userID == user.id)
                  ListItem(
                    title: "Business settings",
                    onTap: () {
                      Navigator.pushNamed(
                          context, ProfileBusinessSettingsScreen.routeName);
                    },
                  ),
                SizedBox(height: 48),
                Container(
                  child: InkWell(
                      child: Text(
                        "Log out",
                        style: TextStyle(color: theme.colors.textMuted),
                      ),
                      onTap: handleLogOut),
                )
              ],
            ));
          },
        ),
      ),
    );
  }
}
