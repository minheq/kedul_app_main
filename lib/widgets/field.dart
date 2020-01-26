import 'package:app_salon/helpers/control.dart';
import 'package:app_salon/theme.dart';
import 'package:app_salon/widgets/spacing.dart';
import 'package:app_salon/widgets/text.dart';
import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  Field(
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
        if (labelText != null) Spacing(4),
        Container(
          height: Control.toDouble(size),
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: Offset(0, 2),
                  blurRadius: 8.0),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: child,
          ),
        )
      ],
    );
  }
}
