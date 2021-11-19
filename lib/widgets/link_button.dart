import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:provider/provider.dart';

class LinkButton extends StatelessWidget {
  LinkButton({
    this.onPressed,
    this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return SizedBox(
        height: theme.utilityStyles.controlHeight,
        child: FlatButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: theme.textStyles.link,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ));
  }
}
