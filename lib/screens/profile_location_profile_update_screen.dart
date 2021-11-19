import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/app/location_model.dart';
import 'package:kedul_app_main/app/location_model.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/bottom_action_bar.dart';
import 'package:kedul_app_main/widgets/error_placeholder.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/loading_placeholder.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:kedul_app_main/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

class ProfileLocationProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/profile_location_profile_update_screen';

  @override
  _ProfileLocationProfileUpdateScreenState createState() {
    return _ProfileLocationProfileUpdateScreenState();
  }
}

class _ProfileLocationProfileUpdateScreenData {
  final Location location;

  _ProfileLocationProfileUpdateScreenData({this.location});
}

class _ProfileLocationProfileUpdateScreenState
    extends State<ProfileLocationProfileUpdateScreen> {
  _ProfileLocationProfileUpdateScreenState();

  UpdateLocationInput _input = UpdateLocationInput();
  bool _isSubmitting = false;
  String _status;
  String _locationID;

  Future<_ProfileLocationProfileUpdateScreenData> _initData() async {
    LocationModel locationModel =
        Provider.of<LocationModel>(context, listen: false);

    Location currentLocation = await locationModel.getCurrentLocation();

    _locationID = currentLocation.id;

    return _ProfileLocationProfileUpdateScreenData(location: currentLocation);
  }

  Future<void> _handleSubmit() async {
    LocationModel locationModel =
        Provider.of<LocationModel>(context, listen: false);
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AnalyticsModel analytics =
        Provider.of<AnalyticsModel>(context, listen: false);

    try {
      analytics.log('update_location');

      setState(() {
        _isSubmitting = true;
      });

      await locationModel.updateLocation(_locationID, _input);

      Navigator.pop(context);
    } on APIErrorException catch (e) {
      setState(() {
        _status = e.message;
      });
    } catch (e, s) {
      analytics.recordError(e, s);

      setState(() {
        _status = l10n.commonSomethingWentWrong;
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MyAppLocalization l10n = MyAppLocalization.of(context);
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Update location profile"),
        ),
        body: FutureBuilder(
          future: _initData(),
          builder: (context,
              AsyncSnapshot<_ProfileLocationProfileUpdateScreenData> snapshot) {
            if (snapshot.hasError) {
              return ErrorPlaceholder(error: snapshot.error);
            }

            if (snapshot.hasData == false) {
              return LoadingPlaceholder();
            }

            Location location = snapshot.data.location;

            return BodyPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ProfilePicture(
                      image: null,
                      name: location.name,
                      size: 120,
                    )
                  ],
                ),
                SizedBox(height: 16.0),
                FormFieldContainer(
                  labelText: l10n.commonFullName,
                  child: TextFormField(
                    initialValue: location.name,
                    onChanged: (name) {
                      _input.name = name;
                    },
                    onFieldSubmitted: (name) {
                      _handleSubmit();
                    },
                  ),
                ),
                if (_status != null) SizedBox(height: 16),
                if (_status != null)
                  Text(
                    _status,
                    style: TextStyle(color: theme.colors.textError),
                  ),
              ],
            ));
          },
        ),
        bottomNavigationBar: BottomActionBar(children: [
          PrimaryButton(
              onPressed: _handleSubmit,
              title: l10n.commonSave,
              isSubmitting: _isSubmitting)
        ]));
  }
}
