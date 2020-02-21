import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/profile_update_phone_number_verify_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/list_item.dart';
import 'package:provider/provider.dart';

class ProfileAccountSettingsScreen extends StatefulWidget {
  static const String routeName = '/profile_account_settings';

  @override
  _ProfileAccountSettingsScreenState createState() {
    return _ProfileAccountSettingsScreenState();
  }
}

class _ProfileAccountSettingsScreenState
    extends State<ProfileAccountSettingsScreen> {
  _ProfileAccountSettingsScreenState();

  @override
  Widget build(BuildContext context) {
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AuthModel authModel = Provider.of<AuthModel>(context);
    User currentUser = authModel.currentUser;
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileAccountSettingsTitle),
      ),
      body: BodyPadding(
          child: Column(
        children: <Widget>[
          ListItem(
            title: l10n.commonPhoneNumber,
            description: currentUser.phoneNumber,
            onTap: () {
              Navigator.pushNamed(
                  context, ProfileUpdatePhoneNumberVerifyScreen.routeName);
            },
          )
        ],
      )),
    );
  }
}
