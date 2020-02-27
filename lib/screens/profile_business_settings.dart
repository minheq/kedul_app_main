import 'package:flutter/material.dart';
import 'package:kedul_app_main/app/business_model.dart';
import 'package:kedul_app_main/app/location_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/error_placeholder.dart';
import 'package:kedul_app_main/widgets/list_item.dart';
import 'package:kedul_app_main/widgets/loading_container.dart';
import 'package:provider/provider.dart';

class ProfileBusinessSettingsScreen extends StatefulWidget {
  static const String routeName = '/profile_business_settings';

  @override
  _ProfileBusinessSettingsScreenState createState() {
    return _ProfileBusinessSettingsScreenState();
  }
}

class _ProfileBusinessSettingsScreenData {
  final Business business;

  _ProfileBusinessSettingsScreenData({this.business});
}

class _ProfileBusinessSettingsScreenState
    extends State<ProfileBusinessSettingsScreen> {
  _ProfileBusinessSettingsScreenState();

  Future<_ProfileBusinessSettingsScreenData> initData() async {
    BusinessModel businessModel =
        Provider.of<BusinessModel>(context, listen: false);
    LocationModel locationModel =
        Provider.of<LocationModel>(context, listen: false);

    Location location = await locationModel.getCurrentLocation();
    Business business =
        await businessModel.getBusinessByID(location.businessID);

    return _ProfileBusinessSettingsScreenData(business: business);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Business settings"),
      ),
      body: FutureBuilder(
        future: initData(),
        builder: (context,
            AsyncSnapshot<_ProfileBusinessSettingsScreenData> snapshot) {
          if (snapshot.hasError) {
            return ErrorPlaceholder(error: snapshot.error);
          }

          if (snapshot.hasData == false) {
            return LoadingPlaceholder();
          }

          Business business = snapshot.data.business;

          return BodyPadding(
              child: Column(
            children: <Widget>[
              ListItem(
                title: business.name,
              )
            ],
          ));
        },
      ),
    );
  }
}
