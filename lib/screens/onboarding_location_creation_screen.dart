import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/app/location_model.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/home_screen.dart';
import 'package:kedul_app_main/screens/onboarding_main_screen.dart';
import 'package:kedul_app_main/storage/storage_model.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/bottom_action_bar.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class OnboardingLocationCreationScreenArguments {
  final String businessID;

  OnboardingLocationCreationScreenArguments(this.businessID);
}

class OnboardingLocationCreationScreen extends StatefulWidget {
  static const String routeName = '/onboarding_location_creation';

  @override
  _OnboardingLocationCreationScreenState createState() {
    return _OnboardingLocationCreationScreenState();
  }
}

class _OnboardingLocationCreationScreenState
    extends State<OnboardingLocationCreationScreen> {
  _OnboardingLocationCreationScreenState();

  String _name = '';
  bool _isSubmitting = false;
  String _status;

  Future<void> handleSubmit() async {
    LocationModel locationModel =
        Provider.of<LocationModel>(context, listen: false);
    StorageModel storageModel =
        Provider.of<StorageModel>(context, listen: false);
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AnalyticsModel analytics =
        Provider.of<AnalyticsModel>(context, listen: false);
    OnboardingLocationCreationScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    try {
      analytics.log('create_location');

      setState(() {
        _isSubmitting = true;
      });

      Location location =
          await locationModel.createLocation(_name, args.businessID);

      await storageModel.write("location_id", location.id);

      Navigator.pushNamed(
        context,
        HomeScreen.routeName,
      );
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

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil(
            (route) => route.settings.name == OnboardingMainScreen.routeName);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(),
          body: BodyPadding(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Give your location a name",
                style: theme.textStyles.headline1,
              ),
              SizedBox(height: 56),
              FormFieldContainer(
                labelText: "Name",
                child: TextFormField(
                  initialValue: "",
                  onChanged: (name) {
                    setState(() {
                      _name = name;
                    });
                  },
                  onFieldSubmitted: (name) {
                    handleSubmit();
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
          )),
          bottomNavigationBar: BottomActionBar(children: [
            PrimaryButton(
                onPressed: handleSubmit,
                title: l10n.commonNext,
                isSubmitting: _isSubmitting)
          ])),
    );
  }
}
