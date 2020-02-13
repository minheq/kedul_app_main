import 'package:flutter/material.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/form/form_builder.dart';
import 'package:kedul_app_main/localization.dart';
import 'package:kedul_app_main/screens/login_verify_check_screen.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/phone_number_form_field.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class LoginVerifyFormValue {
  LoginVerifyFormValue({this.phoneNumber, this.countryCode});

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

  @override
  Widget build(BuildContext context) {
    final l10n = MyAppLocalization.of(context);

    return FormBuilder<LoginVerifyFormValue>(
        onSubmit: (value, helpers) async {
          AuthModel authModel = Provider.of(context, listen: false);

          try {
            String verificationID = await authModel.loginVerify(
                value.phoneNumber, value.countryCode);

            Navigator.pushNamed(
              context,
              LoginVerifyCheckScreen.routeName,
              arguments: ScreenArguments(
                  verificationID, value.phoneNumber, value.countryCode),
            );
          } on APIErrorException catch (e) {
            setState(() {
              helpers.setFormError(e.message);
            });
          } catch (e) {
            // TODO: add error reporting
            print(e);
          } finally {
            helpers.setSubmitting(false);
          }
        },
        initialValues: LoginVerifyFormValue(phoneNumber: '', countryCode: 'VN'),
        builder: (context, form) {
          return Scaffold(
              body: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 56),
                      Image(
                        image: AssetImage('assets/logo.png'),
                        width: 104,
                      ),
                      SizedBox(height: 80),
                      Text(
                        l10n.loginVerifyScreenTitle,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      SizedBox(height: 56),
                      FormFieldContainer(
                        labelText: l10n.commonPhoneNumber,
                        hintText: l10n.loginVerifyScreenAcceptTerms,
                        child: PhoneNumberFormField(
                          initialValue: PhoneNumber(
                              phoneNumber: form.values.phoneNumber,
                              countryCode: form.values.countryCode),
                          onChanged: (value) {
                            form.values.phoneNumber = value.phoneNumber;
                            form.values.countryCode = value.countryCode;
                          },
                          onFieldSubmitted: (PhoneNumber value) {
                            form.handleSubmit();
                          },
                        ),
                      ),
                      SizedBox(height: 4),
                      if (form.status != null)
                        Text(
                          form.status,
                          style: TextStyle(color: Colors.redAccent),
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
