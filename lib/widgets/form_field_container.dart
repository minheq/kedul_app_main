import 'package:kedul_app_main/theme.dart';
import 'package:kedul_app_main/widgets/text.dart';
import 'package:flutter/widgets.dart';
import 'package:kedul_app_main/widgets/touchable_container.dart';

class FormFieldContainer extends StatelessWidget {
  FormFieldContainer(
      {this.key,
      this.errorText,
      this.labelText,
      this.hintText,
      this.child,
      this.keyboardType,
      this.size = ControlSize.md});

  final Key key;
  final String errorText;
  final String labelText;
  final String hintText;
  final ControlSize size;
  final TextInputType keyboardType;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (labelText != null) CustomText(labelText),
        if (labelText != null) SizedBox(height: 4),
        if (hintText != null) CustomText(hintText),
        if (hintText != null) SizedBox(height: 4),
        TouchableContainer(
          child: SizedBox(height: Control.toDouble(size), child: child),
        ),
        if (errorText != null) CustomText(errorText),
        if (errorText != null) SizedBox(height: 4),
      ],
    );
  }
}
