import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/calendar_main_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/BottomActionBar.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/otp_form_field.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LoginVerifyCheckScreenArguments {
  final String verificationID;
  final String phoneNumber;
  final String countryCode;

  LoginVerifyCheckScreenArguments(
      this.verificationID, this.phoneNumber, this.countryCode);
}

class LoginVerifyCheckScreen extends StatefulWidget {
  static const String routeName = '/login_verify_check';

  @override
  _LoginVerifyCheckScreenState createState() {
    return _LoginVerifyCheckScreenState();
  }
}

class _LoginVerifyCheckScreenState extends State<LoginVerifyCheckScreen> {
  _LoginVerifyCheckScreenState();

  final formKey = GlobalKey<FormState>();
  String _code = '';
  bool _isSubmitting = false;
  String _status;

  Future<void> handleLoginVerifyCheck() async {
    LoginVerifyCheckScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    AuthModel auth = Provider.of<AuthModel>(context, listen: false);
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AnalyticsModel analytics =
        Provider.of<AnalyticsModel>(context, listen: false);

    try {
      analytics.log('login_verify_check');

      if (args.verificationID == null) {
        _status = l10n.commonSomethingWentWrong;
        StateError e = StateError(
            'verificationID argument was not passed to LoginVerifyCheckScreen');
        analytics.recordError(e, e.stackTrace);
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      await auth.loginVerifyCheck(args.verificationID, _code);

      Navigator.pushNamed(
        context,
        CalendarMainScreen.routeName,
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
    LoginVerifyCheckScreenArguments args =
        ModalRoute.of(context).settings.arguments;
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Scaffold(
        appBar: AppBar(),
        body: BodyPadding(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.loginVerifyCheckScreenTitle,
              style: theme.textStyles.headline1,
            ),
            SizedBox(height: 16),
            Text(l10n
                .loginVerifyCheckScreenVerificationCodeSent(args.phoneNumber)),
            SizedBox(height: 56),
            FormFieldContainer(
              labelText: l10n.commonVerificationCode,
              child: OTPFormField(
                initialValue: _code,
                onChanged: (code) {
                  _code = code;
                },
                onFieldSubmitted: (code) {
                  handleLoginVerifyCheck();
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
              onPressed: handleLoginVerifyCheck,
              title: l10n.commonNext,
              isSubmitting: _isSubmitting)
        ]));
  }
}
