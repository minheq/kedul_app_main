import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kedul_app_main/theme/theme_model.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatefulWidget {
  ProfilePicture({@required this.image, this.size = 40, this.name});

  final NetworkImage image;
  final int size;
  final String name;

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool _isLoading = true;

  @override
  initState() {
    super.initState();

    if (widget.image == null) {
      return;
    }

    widget.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener(_setImage, onError: _setError));
  }

  void _setImage(ImageInfo image, bool sync) {
    setState(() => _isLoading = false);
  }

  void _setError(dynamic e, StackTrace s) {
    setState(() => _isLoading = false);
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return Container(
      decoration: BoxDecoration(
          color: theme.colors.boxPrimaryLight,
          borderRadius: BorderRadius.circular(999)),
      width: widget.size.toDouble(),
      height: widget.size.toDouble(),
      child: Center(
          child: widget.image == null
              ? _buildInitialsWidget()
              : Image(
                  image: widget.image,
                  width: widget.size.toDouble(),
                  height: widget.size.toDouble(),
                )),
    );
  }

  Widget _buildInitialsWidget() {
    ThemeModel theme = Provider.of<ThemeModel>(context);

    return widget.name == ""
        ? Icon(
            Feather.camera,
            size: widget.size * 0.4,
          )
        : Text(
            _getInitials(widget.name),
            style: theme.textStyles.headline2
                .copyWith(fontSize: widget.size * 0.4),
          );
  }
}

String _getInitials(String name) {
  if (name.isEmpty) return " ";

  List<String> nameArray =
      name.replaceAll(new RegExp(r"\s+\b|\b\s"), " ").split(" ");

  String initials = ((nameArray[0])[0] != null ? (nameArray[0])[0] : " ") +
      (nameArray.length == 1 ? " " : (nameArray[nameArray.length - 1])[0]);

  return initials.toUpperCase();
}
