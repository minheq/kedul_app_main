import 'package:kedul_app_main/theme.dart';
import 'package:kedul_app_main/widgets/text.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    Key key,
    @required this.onPressed,
    this.title,
  });

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ControlHeight.md,
      decoration: BoxDecoration(
        color: NamedColors.buttonPrimary,
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: NamedColors.shadow.withOpacity(0.4),
              offset: Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Material(
        color: NamedColors.transparent,
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
