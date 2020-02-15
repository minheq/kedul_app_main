import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/form/form_builder.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/login_verify_check_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/phone_number_form_field.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class _LoginVerifyFormValue {
  _LoginVerifyFormValue({this.phoneNumber, this.countryCode});

  String phoneNumber;
  String countryCode;
}

class LoginVerifyScreen extends StatefulWidget {
  static const String routeName = '/login_verify';

  @override
  _LoginVerifyScreenState createState() {
    return _LoginVerifyScreenState();
  }
}

class _LoginVerifyScreenState extends State<LoginVerifyScreen> {
  _LoginVerifyScreenState();

  Future<void> handleSubmit(
      _LoginVerifyFormValue values, FormBuilderHelpers helpers) async {
    AuthModel auth = Provider.of<AuthModel>(context, listen: false);
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AnalyticsModel analytics = Provider.of<AnalyticsModel>(context);

    try {
      analytics.log('_LoginVerifyScreenState.handleSubmit');

      String verificationID =
          await auth.loginVerify(values.phoneNumber, values.countryCode);

      Navigator.pushNamed(
        context,
        LoginVerifyCheckScreen.routeName,
        arguments: LoginVerifyCheckScreenArguments(
            verificationID, values.phoneNumber, values.countryCode),
      );
    } on APIErrorException catch (e) {
      setState(() {
        helpers.setStatus(e.message);
      });
    } catch (e, s) {
      analytics.recordError(e, s, context: {
        'phoneNumber': values.phoneNumber,
        'countryCode': values.countryCode,
      });

      setState(() {
        helpers.setStatus(l10n.commonSomethingWentWrong);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MyAppLocalization l10n = MyAppLocalization.of(context);

    return FormBuilder<_LoginVerifyFormValue>(
        initialValues:
            _LoginVerifyFormValue(phoneNumber: '', countryCode: 'VN'),
        onSubmit: handleSubmit,
        builder: (context, form) {
          ThemeModel theme = Provider.of<ThemeModel>(context);

          return Scaffold(
              body: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                          initialValue:
                              PhoneNumber(countryCode: 'VN', phoneNumber: ''),
                          onChanged: (phoneNumber) {
                            form.values.phoneNumber = phoneNumber.phoneNumber;
                            form.values.countryCode = phoneNumber.countryCode;
                          },
                          onFieldSubmitted: (phoneNumber) {
                            form.handleSubmit();
                          },
                        ),
                      ),
                      SizedBox(height: 4),
                      if (form.status != null)
                        Text(
                          form.status,
                          style: TextStyle(color: theme.colors.textError),
                        ),
                    ],
                  )),
              persistentFooterButtons: [
                PrimaryButton(
                    onPressed: form.handleSubmit,
                    title: l10n.commonNext,
                    isSubmitting: form.isSubmitting),
                SizedBox()
              ]);
        });
  }
}
