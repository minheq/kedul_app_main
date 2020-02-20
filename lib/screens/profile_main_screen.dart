import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/auth/user_entity.dart';
import 'package:kedul_app_main/screens/login_verify_screen.dart';
import 'package:kedul_app_main/screens/profile_user_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
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
    AuthModel auth = Provider.of<AuthModel>(context);
    ThemeModel theme = Provider.of<ThemeModel>(context);
    User currentUser = auth.currentUser;

    return Scaffold(
      body: BodyPadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 96),
          _ListItem(
            child: Text(
              currentUser.fullName == "" ? "Setup profile" : "See all",
              style: theme.textStyles.link,
            ),
            onTap: () {
              Navigator.pushNamed(context, ProfileUserScreen.routeName);
            },
          ),
          Container(
            child: InkWell(
                child: Text(
                  "Log out",
                  style: theme.textStyles.link,
                ),
                onTap: handleLogOut),
          )
        ],
      )),
    );
  }
}

class _ListItem extends StatelessWidget {
  _ListItem({this.child, this.onTap});

  final Widget child;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Container(
      height: theme.utilityStyles.controlHeight,
      child: InkWell(child: child, onTap: onTap),
    );
  }
}
