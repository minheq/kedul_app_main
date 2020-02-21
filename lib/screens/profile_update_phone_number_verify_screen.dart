import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/profile_update_phone_number_check_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/bottom_action_bar.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/phone_number_form_field.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class ProfileUpdatePhoneNumberVerifyScreen extends StatefulWidget {
  static const String routeName = '/profile_update_phone_number_verify';

  @override
  _ProfileUpdatePhoneNumberVerifyScreenState createState() {
    return _ProfileUpdatePhoneNumberVerifyScreenState();
  }
}

class _ProfileUpdatePhoneNumberVerifyScreenState
    extends State<ProfileUpdatePhoneNumberVerifyScreen> {
  _ProfileUpdatePhoneNumberVerifyScreenState();

  String _phoneNumber = '';
  String _countryCode = 'VN';
  bool _isSubmitting = false;
  String _status;

  Future<void> handleUpdatePhoneNumberVerify() async {
    AuthModel auth = Provider.of<AuthModel>(context, listen: false);
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AnalyticsModel analytics =
        Provider.of<AnalyticsModel>(context, listen: false);

    try {
      analytics.log('update_phone_number_verify');

      setState(() {
        _isSubmitting = true;
      });

      String verificationID =
          await auth.updatePhoneNumberVerify(_phoneNumber, _countryCode);

      Navigator.pushNamed(
        context,
        ProfileUpdatePhoneNumberCheckScreen.routeName,
        arguments: ProfileUpdatePhoneNumberCheckScreenArguments(
            verificationID, _phoneNumber, _countryCode),
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
    AuthModel auth = Provider.of<AuthModel>(context);
    User currentUser = auth.currentUser;

    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.profileUpdatePhoneNumberVerifyTitle),
        ),
        body: BodyPadding(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormFieldContainer(
              labelText: l10n.commonPhoneNumber,
              child: PhoneNumberFormField(
                initialValue: PhoneNumber(
                    countryCode: currentUser.countryCode,
                    phoneNumber: currentUser.phoneNumber),
                onChanged: (phoneNumber) {
                  setState(() {
                    _phoneNumber = phoneNumber.phoneNumber;
                    _countryCode = phoneNumber.countryCode;
                  });
                },
                onFieldSubmitted: (phoneNumber) {
                  handleUpdatePhoneNumberVerify();
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
              onPressed: handleUpdatePhoneNumberVerify,
              title: l10n.commonNext,
              isSubmitting: _isSubmitting)
        ]));
  }
}
