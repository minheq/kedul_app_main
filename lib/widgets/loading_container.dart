import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/spinner_three_bounce.dart';
import 'package:provider/provider.dart';

class LoadingPlaceholder extends StatelessWidget {
  LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        SpinnerThreeBounce(
          color: theme.colors.textPrimary,
          size: 40.0,
        )
      ],
    );
  }
}
