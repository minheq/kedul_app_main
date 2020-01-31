import 'package:kedul_app_main/theme.dart';
import 'package:kedul_app_main/helpers/control.dart';
import 'package:kedul_app_main/widgets/text.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button(
      {Key key,
      @required this.onPressed,
      this.title,
      this.size = ControlSize.md});

  final ControlSize size;
  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Control.toDouble(size),
      decoration: BoxDecoration(
        color: CustomColors.buttonPrimary,
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              offset: Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Material(
        color: CustomColors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
          onTap: onPressed,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.0),
              child: CustomText(
                title,
                color: TextColor.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
