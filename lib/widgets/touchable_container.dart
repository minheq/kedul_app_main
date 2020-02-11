import 'package:kedul_app_main/theme.dart';
import 'package:flutter/widgets.dart';

class TouchableContainer extends StatelessWidget {
  TouchableContainer({
    this.key,
    this.child,
  });

  final Key key;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NamedColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: NamedColors.shadow.withOpacity(0.2),
              offset: Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: child,
    );
  }
}
