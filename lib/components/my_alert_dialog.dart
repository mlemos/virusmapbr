import 'package:flutter/material.dart';
import 'package:virusmapbr/themes/themes.dart';

class MyAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  MyAlertDialog({this.title, this.content, this.actions, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      backgroundColor: VirusMapBRTheme.color(context, "modal"),
      actions: actions,
    );
  }
}
