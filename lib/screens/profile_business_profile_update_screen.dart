import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/app/business_model.dart';
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

class ProfileBusinessProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/profile_business_profile_update_screen';

  @override
  _ProfileBusinessProfileUpdateScreenState createState() {
    return _ProfileBusinessProfileUpdateScreenState();
  }
}

class _ProfileBusinessProfileUpdateScreenData {
  final Business business;

  _ProfileBusinessProfileUpdateScreenData({this.business});
}

class _ProfileBusinessProfileUpdateScreenState
    extends State<ProfileBusinessProfileUpdateScreen> {
  _ProfileBusinessProfileUpdateScreenState();

  UpdateBusinessInput _input = UpdateBusinessInput();
  bool _isSubmitting = false;
  String _status;
  String _businessID;

  Future<_ProfileBusinessProfileUpdateScreenData> _initData() async {
    BusinessModel businessModel =
        Provider.of<BusinessModel>(context, listen: false);
    LocationModel locationModel =
        Provider.of<LocationModel>(context, listen: false);

    Location currentLocation = await locationModel.getCurrentLocation();
    Business business =
        await businessModel.getBusinessByID(currentLocation.businessID);

    _businessID = business.id;

    return _ProfileBusinessProfileUpdateScreenData(business: business);
  }

  Future<void> _handleSubmit() async {
    BusinessModel businessModel =
        Provider.of<BusinessModel>(context, listen: false);
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AnalyticsModel analytics =
        Provider.of<AnalyticsModel>(context, listen: false);

    try {
      analytics.log('update_business');

      setState(() {
        _isSubmitting = true;
      });

      await businessModel.updateBusiness(_businessID, _input);

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
          title: Text("Update business profile"),
        ),
        body: FutureBuilder(
          future: _initData(),
          builder: (context,
              AsyncSnapshot<_ProfileBusinessProfileUpdateScreenData> snapshot) {
            if (snapshot.hasError) {
              return ErrorPlaceholder(error: snapshot.error);
            }

            if (snapshot.hasData == false) {
              return LoadingPlaceholder();
            }

            Business business = snapshot.data.business;

            return BodyPadding(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ProfilePicture(
                      image: null,
                      name: business.name,
                      size: 120,
                    )
                  ],
                ),
                SizedBox(height: 16.0),
                FormFieldContainer(
                  labelText: l10n.commonFullName,
                  child: TextFormField(
                    initialValue: business.name,
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
