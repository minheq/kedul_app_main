import 'package:flutter/material.dart';
import 'package:kedul_app_main/auth/auth_model.dart';
import 'package:kedul_app_main/l10n/localization.dart';
import 'package:kedul_app_main/screens/profile_update_phone_number_verify_screen.dart';
import 'package:kedul_app_main/widgets/body_padding.dart';
import 'package:kedul_app_main/widgets/error_placeholder.dart';
import 'package:kedul_app_main/widgets/list_item.dart';
import 'package:kedul_app_main/widgets/loading_placeholder.dart';
import 'package:provider/provider.dart';

class ProfileAccountSettingsScreen extends StatefulWidget {
  static const String routeName = '/profile_account_settings';

  @override
  _ProfileAccountSettingsScreenState createState() {
    return _ProfileAccountSettingsScreenState();
  }
}

class _ProfileAccountSettingsScreenData {
  final User currentUser;

  _ProfileAccountSettingsScreenData({this.currentUser});
}

class _ProfileAccountSettingsScreenState
    extends State<ProfileAccountSettingsScreen> {
  _ProfileAccountSettingsScreenState();

  Future<_ProfileAccountSettingsScreenData> _initData() async {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    User currentUser = await authModel.getCurrentUser();

    return _ProfileAccountSettingsScreenData(currentUser: currentUser);
  }

  @override
  Widget build(BuildContext context) {
    MyAppLocalization l10n = MyAppLocalization.of(context);
    Provider.of<AuthModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileAccountSettingsTitle),
      ),
      body: FutureBuilder(
        future: _initData(),
        builder: (context,
            AsyncSnapshot<_ProfileAccountSettingsScreenData> snapshot) {
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
              ListItem(
                title: l10n.commonPhoneNumber,
                description: currentUser.phoneNumber,
                onTap: () {
                  Navigator.pushNamed(
                      context, ProfileUpdatePhoneNumberVerifyScreen.routeName);
                },
              )
            ],
          ));
        },
      ),
    );
  }
}
