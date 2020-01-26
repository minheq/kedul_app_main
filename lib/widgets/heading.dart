import 'package:flutter/widgets.dart';

enum HeadingSize { xs, sm, md, lg, xl, xxl }

class Heading extends StatelessWidget {
  Heading(this.data,
      {Key key, this.size = HeadingSize.md, this.textAlign = TextAlign.left});

  final String data;
  final HeadingSize size;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style:
          TextStyle(fontWeight: FontWeight.bold, fontSize: getFontSize(size)),
    );
  }

  static double getFontSize(HeadingSize size) {
    switch (size) {
      case HeadingSize.xs:
        return 12.8;
      case HeadingSize.sm:
        return 16.0;
      case HeadingSize.md:
        return 20.0;
      case HeadingSize.lg:
        return 25.0;
      case HeadingSize.xl:
        return 31.0;
      case HeadingSize.xxl:
        return 39.0;
      default:
        return 18.0;
    }
  }
}
