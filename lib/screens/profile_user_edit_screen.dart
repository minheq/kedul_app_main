import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/bottom_action_bar.dart';
import 'package:kedul_app_main/widgets/form_field_container.dart';
import 'package:kedul_app_main/widgets/primary_button.dart';
import 'package:kedul_app_main/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

class ProfileUserEditScreen extends StatefulWidget {
  static const String routeName = '/profile_user_edit_screen';

  @override
  _ProfileUserEditScreenState createState() {
    return _ProfileUserEditScreenState();
  }
}

class _ProfileUserEditScreenState extends State<ProfileUserEditScreen> {
  _ProfileUserEditScreenState();

  String _fullName;
  String _profileImageID;
  bool _isSubmitting = false;
  String _status;

  Future<void> handleUpdateUserProfile() async {
    AuthModel auth = Provider.of<AuthModel>(context, listen: false);
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AnalyticsModel analytics =
        Provider.of<AnalyticsModel>(context, listen: false);

    try {
      analytics.log('update_user_profile');

      setState(() {
        _isSubmitting = true;
      });

      await auth.updateUserProfile(_fullName, _profileImageID);

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
    AuthModel authModel = Provider.of<AuthModel>(context);
    User currentUser = authModel.currentUser;
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Scaffold(
        appBar: AppBar(),
        body: BodyPadding(
            child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ProfilePicture(
                  image: null,
                  name: currentUser.fullName,
                  size: 120,
                )
              ],
            ),
            SizedBox(height: 16.0),
            FormFieldContainer(
              labelText: l10n.commonFullName,
              child: TextFormField(
                initialValue: currentUser.fullName,
                onChanged: (name) {
                  _fullName = name;
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
              onPressed: handleUpdateUserProfile,
              title: l10n.commonSave,
              isSubmitting: _isSubmitting)
        ]));
  }
}
