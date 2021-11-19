import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/screens/profile_user_profile_update_screen.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/error_placeholder.dart';
import 'package:kedul_app_main/widgets/link_button.dart';
import 'package:kedul_app_main/widgets/loading_placeholder.dart';
import 'package:kedul_app_main/widgets/profile_view.dart';
import 'package:provider/provider.dart';

class ProfileUserDetailsScreen extends StatefulWidget {
  static const String routeName = '/profile_user_details';

  @override
  _ProfileUserDetailsScreenState createState() {
    return _ProfileUserDetailsScreenState();
  }
}

class _ProfileUserDetailsData {
  final User currentUser;

  _ProfileUserDetailsData({this.currentUser});
}

class _ProfileUserDetailsScreenState extends State<ProfileUserDetailsScreen> {
  _ProfileUserDetailsScreenState();

  Future<_ProfileUserDetailsData> _initData() async {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    User currentUser = await authModel.getCurrentUser();

    return _ProfileUserDetailsData(currentUser: currentUser);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: <Widget>[
          LinkButton(
              title: "Edit",
              onPressed: () {
                Navigator.pushNamed(
                    context, ProfileUserProfileUpdateScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future: _initData(),
        builder: (context, AsyncSnapshot<_ProfileUserDetailsData> snapshot) {
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
              ProfileView(
                name: currentUser.fullName,
                image: null,
              )
            ],
          ));
        },
      ),
    );
  }
}
