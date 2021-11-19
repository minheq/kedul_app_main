import 'package:flutter/material.dart';
import 'package:kedul_app_main/analytics/analytics_model.dart';
import 'package:kedul_app_main/api/api_error_exception.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
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

class ProfileUserProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/profile_user_profile_update_screen';

  @override
  _ProfileUserProfileUpdateScreenState createState() {
    return _ProfileUserProfileUpdateScreenState();
  }
}

class _ProfileUserProfileUpdateScreenData {
  final User currentUser;

  _ProfileUserProfileUpdateScreenData({this.currentUser});
}

class _ProfileUserProfileUpdateScreenState
    extends State<ProfileUserProfileUpdateScreen> {
  _ProfileUserProfileUpdateScreenState();

  String _fullName;
  String _profileImageID;
  bool _isSubmitting = false;
  String _status;

  Future<_ProfileUserProfileUpdateScreenData> _initData() async {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    User currentUser = await authModel.getCurrentUser();

    return _ProfileUserProfileUpdateScreenData(currentUser: currentUser);
  }

  Future<void> handleSubmit() async {
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
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future: _initData(),
          builder: (context,
              AsyncSnapshot<_ProfileUserProfileUpdateScreenData> snapshot) {
            if (snapshot.hasError) {
              return ErrorPlaceholder(error: snapshot.error);
            }

            if (snapshot.hasData == false) {
              return LoadingPlaceholder();
            }

            User currentUser = snapshot.data.currentUser;

            return BodyPadding(
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
            ));
          },
        ),
        bottomNavigationBar: BottomActionBar(children: [
          PrimaryButton(
              onPressed: handleSubmit,
              title: l10n.commonSave,
              isSubmitting: _isSubmitting)
        ]));
  }
}
