import 'package:app_salon/theme.dart';
import 'package:flutter/material.dart';

enum TextSize { sm, md, lg, xl }
enum TextColor { dark, muted, link, white }

class CustomText extends StatelessWidget {
  CustomText(this.data,
      {Key key,
      this.size = TextSize.md,
      this.color = TextColor.dark,
      this.fontWeight = FontWeight.normal});

  final String data;
  final TextSize size;
  final TextColor color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(data,
        style: TextStyle(
            fontSize: getFontSize(size),
            color: getColor(color),
            fontWeight: fontWeight));
  }

  static double getFontSize(TextSize size) {
    switch (size) {
      case TextSize.sm:
        return 12.8;
      case TextSize.md:
        return 16.0;
      case TextSize.lg:
        return 20.0;
      case TextSize.xl:
        return 25.0;
      default:
        return 16.0;
    }
  }

  static Color getColor(TextColor color) {
    switch (color) {
      case TextColor.dark:
        return CustomColors.textDark;
      case TextColor.muted:
        return CustomColors.textMuted;
      case TextColor.link:
        return CustomColors.textPrimary;
      case TextColor.white:
        return CustomColors.white;
      default:
        return CustomColors.textDark;
    }
  }
}
