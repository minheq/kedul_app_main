import 'package:kedul_app_main/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TouchableContainer extends StatelessWidget {
  TouchableContainer({
    this.key,
    this.child,
  });

  final Key key;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colors.content,
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
        boxShadow: <BoxShadow>[
          theme.colors.shadow,
        ],
      ),
      child: child,
    );
  }
}
