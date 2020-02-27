import 'package:flutter/material.dart';
import 'package:kedul_app_main/app/business_model.dart';
import 'package:kedul_app_main/app/location_model.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/screens/calendar_main_screen.dart';
import 'package:kedul_app_main/screens/home_screen.dart';
import 'package:kedul_app_main/screens/onboarding_business_creation_screen.dart';
import 'package:kedul_app_main/screens/onboarding_location_creation_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/error_placeholder.dart';
import 'package:kedul_app_main/widgets/link_button.dart';
import 'package:kedul_app_main/widgets/list_item.dart';
import 'package:kedul_app_main/widgets/loading_placeholder.dart';
import 'package:kedul_app_main/widgets/profile_picture.dart';
import 'package:kedul_app_main/widgets/text_link.dart';
import 'package:provider/provider.dart';

class OnboardingLocationSelectionScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  @override
  OnboardingLocationSelectionScreenState createState() {
    return OnboardingLocationSelectionScreenState();
  }
}

class _OnboardingLocationSelectionScreenData {
  final List<Business> businesses;
  final List<Location> locations;

  _OnboardingLocationSelectionScreenData({this.businesses, this.locations});
}

class OnboardingLocationSelectionScreenState
    extends State<OnboardingLocationSelectionScreen> {
  OnboardingLocationSelectionScreenState();

  Business _selectedBusiness;

  Future<_OnboardingLocationSelectionScreenData> initData() async {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    BusinessModel businessModel =
        Provider.of<BusinessModel>(context, listen: false);
    LocationModel locationModel =
        Provider.of<LocationModel>(context, listen: false);

    User user = await authModel.getCurrentUser();
    List<Business> businesses =
        await businessModel.getBusinessesByUserID(user.id);

    List<Location> locations = [];

    if (_selectedBusiness != null) {
      locations = await locationModel.getLocationsByUserIDAndBusinessID(
          user.id, _selectedBusiness.id);
    }

    return _OnboardingLocationSelectionScreenData(
        businesses: businesses, locations: locations);
  }

  void handleSelectBusiness(Business business) {
    setState(() {
      _selectedBusiness = business;
    });
  }

  void handleChangeBusiness() {
    setState(() {
      _selectedBusiness = null;
    });
  }

  void handleSelectLocation(Location location) {
    LocationModel locationModel =
        Provider.of<LocationModel>(context, listen: false);
    locationModel.setCurrentLocation(location);
    Navigator.pushNamed(context, HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);
    // Subscriptions
    Provider.of<AuthModel>(context);
    Provider.of<BusinessModel>(context);
    Provider.of<LocationModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: BodyPadding(
          child: FutureBuilder(
              future: initData(),
              builder: (BuildContext context,
                  AsyncSnapshot<_OnboardingLocationSelectionScreenData>
                      snapshot) {
                if (snapshot.hasError) {
                  return ErrorPlaceholder();
                }

                if (snapshot.hasData == false) {
                  return LoadingPlaceholder();
                }

                if (snapshot.data.businesses.length == 0) {
                  return OnboardingBusinessCreationScreen();
                }

                List<Widget> businessWidgetList = [];

                for (Business business in snapshot.data.businesses) {
                  businessWidgetList.add(ListItem(
                    image: ProfilePicture(
                      image: null,
                      name: business.name,
                      size: 48,
                    ),
                    title: business.name,
                    onTap: () {
                      handleSelectBusiness(business);
                    },
                  ));
                }

                List<Widget> locationWidgetList = [];

                if (_selectedBusiness != null) {
                  for (Location location in snapshot.data.locations) {
                    locationWidgetList.add(ListItem(
                      image: ProfilePicture(
                        image: null,
                        name: location.name,
                        size: 48,
                      ),
                      title: location.name,
                      onTap: () {
                        handleSelectLocation(location);
                      },
                    ));
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Select your workspace",
                      style: theme.textStyles.headline1,
                    ),
                    SizedBox(height: 24),
                    if (_selectedBusiness == null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Choose business",
                            style: theme.textStyles.headline3,
                          ),
                          SizedBox(height: 16),
                          TextLink("+ Create new business", onTap: () {
                            Navigator.pushNamed(context,
                                OnboardingBusinessCreationScreen.routeName);
                          }),
                          SizedBox(height: 16),
                          Column(
                            children: businessWidgetList,
                          ),
                        ],
                      ),
                    if (_selectedBusiness != null)
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  child: ListItem(
                                image: null,
                                title: _selectedBusiness.name,
                              )),
                              LinkButton(
                                  title: "Change",
                                  onPressed: () {
                                    handleChangeBusiness();
                                  })
                            ],
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    if (_selectedBusiness != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Choose location",
                            style: theme.textStyles.headline3,
                          ),
                          SizedBox(height: 16),
                          TextLink("+ Create new location", onTap: () {
                            Navigator.pushNamed(context,
                                OnboardingLocationCreationScreen.routeName,
                                arguments:
                                    OnboardingLocationCreationScreenArguments(
                                        _selectedBusiness.id));
                          }),
                          SizedBox(height: 16),
                          Column(
                            children: locationWidgetList,
                          ),
                        ],
                      )
                  ],
                );
              })),
    );
  }
}
