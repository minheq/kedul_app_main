import 'package:flutter/widgets.dart';

class Spacing extends StatelessWidget {
  /// Creates a spacing widget. It will use [height] to create vertical whitespace
  ///
  /// Defaults to 16 height

  Spacing([this.height = 16, Key key]);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: this.height);
  }
}
