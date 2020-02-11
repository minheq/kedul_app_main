import 'package:kedul_app_main/theme.dart';
import 'package:flutter/material.dart';
import 'package:kedul_app_main/widgets/touchable_container.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (labelText != null) Text(labelText),
        if (labelText != null) SizedBox(height: 4),
        if (hintText != null) Text(hintText),
        if (hintText != null) SizedBox(height: 4),
        TouchableContainer(
          child: SizedBox(height: ControlHeight.md, child: child),
        ),
        if (errorText != null) Text(errorText),
        if (errorText != null) SizedBox(height: 4),
      ],
    );
  }
}
