import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:kedul_app_main/widgets/spinner_three_bounce.dart';
import 'package:provider/provider.dart';

class LoadingPlaceholder extends StatefulWidget {
  LoadingPlaceholder({this.timeoutMs = const Duration(milliseconds: 500)});
  final Duration timeoutMs;

  @override
  _LoadingPlaceholderState createState() {
    return _LoadingPlaceholderState();
  }
}

class _LoadingPlaceholderState extends State<LoadingPlaceholder> {
  Timer _timer;
  bool shouldShowSpinner = false;

  @override
  void initState() {
    _timer = Timer(widget.timeoutMs, () {
      setState(() {
        shouldShowSpinner = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        if (shouldShowSpinner == true)
          SpinnerThreeBounce(
            color: theme.colors.textPrimary,
            size: 40.0,
          )
      ],
    );
  }
}
