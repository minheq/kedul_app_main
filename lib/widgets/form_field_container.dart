import 'package:kedul_app_main/theme.dart';
import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/touchable_container.dart';
import 'package:provider/provider.dart';

class FormFieldContainer extends StatelessWidget {
  FormFieldContainer({
    this.errorText,
    this.labelText,
    this.hintText,
    this.child,
  });

  final String errorText;
  final String labelText;
  final String hintText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (labelText != null)
          Text(
            labelText,
            style: TextStyle(color: theme.colors.textMuted),
          ),
        if (labelText != null) SizedBox(height: 4.0),
        TouchableContainer(
          child:
              SizedBox(height: theme.utilityStyles.controlHeight, child: child),
        ),
        if (hintText != null) SizedBox(height: 16.0),
        if (hintText != null)
          Text(
            hintText,
            style: theme.textStyles.caption
                .copyWith(color: theme.colors.textMuted),
          ),
        if (errorText != null) SizedBox(height: 16.0),
        if (errorText != null)
          Text(
            errorText,
            style: TextStyle(color: theme.colors.textError),
          ),
      ],
    );
  }
}
