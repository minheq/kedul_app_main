import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:provider/provider.dart';

class TextLink extends StatelessWidget {
  TextLink(
    this.text, {
    this.onTap,
  });

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            text,
            style: theme.textStyles.link,
          ),
        ),
        onTap: onTap);
  }
}
