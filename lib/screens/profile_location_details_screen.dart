import 'package:flutter/material.dart';
import 'package:kedul_app_main/app/location_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/error_placeholder.dart';
import 'package:kedul_app_main/widgets/list_item.dart';
import 'package:kedul_app_main/widgets/loading_placeholder.dart';
import 'package:provider/provider.dart';

class ProfileLocationDetailsScreen extends StatefulWidget {
  static const String routeName = '/profile_location_details';

  @override
  _ProfileLocationDetailsScreenState createState() {
    return _ProfileLocationDetailsScreenState();
  }
}

class _ProfileLocationDetailsScreenData {
  final Location location;

  _ProfileLocationDetailsScreenData({this.location});
}

class _ProfileLocationDetailsScreenState
    extends State<ProfileLocationDetailsScreen> {
  _ProfileLocationDetailsScreenState();

  Future<_ProfileLocationDetailsScreenData> initData() async {
    LocationModel locationModel =
        Provider.of<LocationModel>(context, listen: false);

    Location location = await locationModel.getCurrentLocation();

    return _ProfileLocationDetailsScreenData(location: location);
  }

  @override
  Widget build(BuildContext context) {
    // Subscriptions
    Provider.of<LocationModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: FutureBuilder(
        future: initData(),
        builder: (context,
            AsyncSnapshot<_ProfileLocationDetailsScreenData> snapshot) {
          if (snapshot.hasError) {
            return ErrorPlaceholder(error: snapshot.error);
          }

          if (snapshot.hasData == false) {
            return LoadingPlaceholder();
          }

          Location location = snapshot.data.location;

          return BodyPadding(
              child: Column(
            children: <Widget>[
              ListItem(
                title: location.name,
              )
            ],
          ));
        },
      ),
    );
  }
}
