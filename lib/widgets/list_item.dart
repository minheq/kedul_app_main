import 'package:flutter/material.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:provider/provider.dart';

class ListItem extends StatelessWidget {
  ListItem({this.title, this.description, this.image, this.action, this.onTap});

  final String title;
  final String description;

  final Widget image;
  final Widget action;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return InkWell(
        child: Container(
          height: theme.utilityStyles.controlHeight,
          child: Row(
            children: <Widget>[
              Container(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (image != null) image,
                  if (image != null) SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (title != null)
                        Text(
                          title,
                          style: theme.textStyles.bodyText1,
                        ),
                      if (description != null)
                        Text(
                          description,
                          style: theme.textStyles.bodyText2
                              .copyWith(color: theme.colors.textMuted),
                        ),
                    ],
                  )
                ],
              )),
              if (action != null) action
            ],
          ),
        ),
        onTap: onTap);
  }
}
