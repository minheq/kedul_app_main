import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/login_verify_check_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/BottomActionBar.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/phone_number_form_field.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LoginVerifyScreen extends StatefulWidget {
  static const String routeName = '/login_verify';

  @override
  _LoginVerifyScreenState createState() {
    return _LoginVerifyScreenState();
  }
}

class _LoginVerifyScreenState extends State<LoginVerifyScreen> {
  _LoginVerifyScreenState();

  String _phoneNumber = '';
  String _countryCode = 'VN';
  bool _isSubmitting = false;
  String _status;

  Future<void> handleLoginVerify() async {
    AuthModel auth = Provider.of<AuthModel>(context, listen: false);
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AnalyticsModel analytics =
        Provider.of<AnalyticsModel>(context, listen: false);

    try {
      analytics.log('login_verify');

      setState(() {
        _isSubmitting = true;
      });

      String verificationID =
          await auth.loginVerify(_phoneNumber, _countryCode);

      Navigator.pushNamed(
        context,
        LoginVerifyCheckScreen.routeName,
        arguments: LoginVerifyCheckScreenArguments(
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

    return Scaffold(
        body: BodyPadding(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Image(
              image: AssetImage('assets/logo.png'),
              width: 104,
            ),
            SizedBox(height: 40),
            Text(
              l10n.loginVerifyScreenTitle,
              style: theme.textStyles.headline1,
            ),
            SizedBox(height: 56),
            FormFieldContainer(
              labelText: l10n.commonPhoneNumber,
              hintText: l10n.loginVerifyScreenAcceptTerms,
              child: PhoneNumberFormField(
                initialValue: PhoneNumber(countryCode: 'VN', phoneNumber: ''),
                onChanged: (phoneNumber) {
                  setState(() {
                    _phoneNumber = phoneNumber.phoneNumber;
                    _countryCode = phoneNumber.countryCode;
                  });
                },
                onFieldSubmitted: (phoneNumber) {
                  handleLoginVerify();
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
              onPressed: handleLoginVerify,
              title: l10n.commonNext,
              isSubmitting: _isSubmitting)
        ]));
  }
}
