import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/screens/profile_user_profile_update_screen.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

class ProfileUserDetailsScreen extends StatefulWidget {
  static const String routeName = '/profile_user_details';

  @override
  _ProfileUserDetailsScreenState createState() {
    return _ProfileUserDetailsScreenState();
  }
}

class _ProfileUserDetailsScreenState extends State<ProfileUserDetailsScreen> {
  _ProfileUserDetailsScreenState();

  @override
  Widget build(BuildContext context) {
    AuthModel auth = Provider.of<AuthModel>(context);
    ThemeModel theme = Provider.of<ThemeModel>(context);
    User currentUser = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          InkWell(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "Edit",
                    style: theme.textStyles.link,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(
                    context, ProfileUserProfileUpdateScreen.routeName);
              })
        ],
      ),
      body: BodyPadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Text(currentUser.fullName),
        ],
      )),
    );
  }
}
