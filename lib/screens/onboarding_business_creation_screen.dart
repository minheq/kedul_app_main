import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/app/business_model.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/onboarding_location_creation_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/bottom_action_bar.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class OnboardingBusinessCreationScreen extends StatefulWidget {
  static const String routeName = '/onboarding_business_creation';

  @override
  _OnboardingBusinessCreationScreenState createState() {
    return _OnboardingBusinessCreationScreenState();
  }
}

class _OnboardingBusinessCreationScreenState
    extends State<OnboardingBusinessCreationScreen> {
  _OnboardingBusinessCreationScreenState();

  String _name = '';
  bool _isSubmitting = false;
  String _status;

  Future<void> handleSubmit() async {
    BusinessModel businessModel =
        Provider.of<BusinessModel>(context, listen: false);
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AnalyticsModel analytics =
        Provider.of<AnalyticsModel>(context, listen: false);

    try {
      analytics.log('create_business');

      setState(() {
        _isSubmitting = true;
      });

      Business business = await businessModel.createBusiness(_name);

      Navigator.pushNamed(
        context,
        OnboardingLocationCreationScreen.routeName,
        arguments: OnboardingLocationCreationScreenArguments(business.id),
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

    return Scaffold(
        appBar: AppBar(),
        body: BodyPadding(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Give your business a name",
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
        ]));
  }
}
