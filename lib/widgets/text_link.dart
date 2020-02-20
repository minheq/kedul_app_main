import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextLink extends StatelessWidget {
  TextLink(this.data, this.routeName);

  final String data;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return InkWell(
      child: Text(data,
          style: theme.textStyles.bodyText2
              .copyWith(color: theme.colors.textLink)),
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}
