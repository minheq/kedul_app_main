import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  ProfileView({this.name, this.image});

  final String name;
  final NetworkImage image;

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProfilePicture(
              image: image,
              name: name,
              size: 120,
            )
          ],
        ),
        SizedBox(height: 16.0),
        Text(name, style: theme.textStyles.headline1),
      ],
    );
  }
}
