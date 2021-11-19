import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/home_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/bottom_action_bar.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/otp_form_field.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LoginCheckScreenArguments {
  final String verificationID;
  final String phoneNumber;
  final String countryCode;

  LoginCheckScreenArguments(
      this.verificationID, this.phoneNumber, this.countryCode);
}

class LoginCheckScreen extends StatefulWidget {
  static const String routeName = '/login_check';

  @override
  _LoginCheckScreenState createState() {
    return _LoginCheckScreenState();
  }
}

class _LoginCheckScreenState extends State<LoginCheckScreen> {
  _LoginCheckScreenState();

  final formKey = GlobalKey<FormState>();
  String _code = '';
  bool _isSubmitting = false;
  String _status;

  Future<void> handleSubmit() async {
    LoginCheckScreenArguments args = ModalRoute.of(context).settings.arguments;
    AuthModel auth = Provider.of<AuthModel>(context, listen: false);
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AnalyticsModel analytics =
        Provider.of<AnalyticsModel>(context, listen: false);

    try {
      analytics.log('login_check');

      if (args.verificationID == null) {
        _status = l10n.commonSomethingWentWrong;
        StateError e = StateError(
            'verificationID argument was not passed to LoginCheckScreen');
        analytics.recordError(e, e.stackTrace);
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      await auth.loginCheck(args.verificationID, _code);

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
    LoginCheckScreenArguments args = ModalRoute.of(context).settings.arguments;
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Scaffold(
        appBar: AppBar(),
        body: BodyPadding(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.loginCheckScreenTitle,
              style: theme.textStyles.headline1,
            ),
            SizedBox(height: 16),
            Text(l10n.loginCheckScreenVerificationCodeSent(args.phoneNumber)),
            SizedBox(height: 56),
            FormFieldContainer(
              labelText: l10n.commonVerificationCode,
              child: OTPFormField(
                initialValue: _code,
                onChanged: (code) {
                  _code = code;
                },
                onFieldSubmitted: (code) {
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
