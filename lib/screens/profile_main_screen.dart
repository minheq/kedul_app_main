import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';
import 'package:kedul_app_main/screens/profile_account_settings.dart';
import 'package:kedul_app_main/screens/profile_user_details_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/list_item.dart';
import 'package:kedul_app_main/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

class ProfileMainScreen extends StatefulWidget {
  @override
  _ProfileMainScreenState createState() {
    return _ProfileMainScreenState();
  }
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {
  _ProfileMainScreenState();

  Future<void> handleLogOut() async {
    AuthModel auth = Provider.of<AuthModel>(context, listen: false);

    await auth.logOut();

    Navigator.pushReplacementNamed(context, LoginVerifyScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    MyAppLocalization l10n = MyAppLocalization.of(context);
    AuthModel auth = Provider.of<AuthModel>(context);
    ThemeModel theme = Provider.of<ThemeModel>(context);
    User currentUser = auth.currentUser;

    return Scaffold(
      body: SafeArea(
        child: BodyPadding(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListItem(
              image: ProfilePicture(
                image: null,
                name: currentUser.fullName,
                size: 48,
              ),
              title: currentUser.fullName == ""
                  ? "Setup profile"
                  : currentUser.fullName,
              onTap: () {
                Navigator.pushNamed(
                    context, ProfileUserDetailsScreen.routeName);
              },
            ),
            ListItem(
              title: l10n.profileAccountSettingsTitle,
              onTap: () {
                Navigator.pushNamed(
                    context, ProfileAccountSettingsScreen.routeName);
              },
            ),
            SizedBox(height: 48),
            Container(
              child: InkWell(
                  child: Text(
                    "Log out",
                    style: TextStyle(color: theme.colors.textMuted),
                  ),
                  onTap: handleLogOut),
            )
          ],
        )),
      ),
    );
  }
}
