import 'package:flutter/material.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/models/session.dart';
import 'package:virusmapbr/themes/themes.dart';

import 'my_alert_dialog.dart';

class LogoutOption extends StatelessWidget {
  final Session session;
  final VoidCallback onConfirmed;

  @override
  LogoutOption(this.session, {this.onConfirmed, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.all(0),
      onPressed: () async {
        await _showConfirmExit(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: VirusMapBRTheme.color(context, "error").withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              VirusMapBRIcons.logout,
              color: VirusMapBRTheme.color(context, "error"),
              size: 24.0,
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text("Encerrar sessão",
                style: Theme.of(context).textTheme.subtitle1.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "error")))),
          ),
        ],
      ),
    );
  }

  Future _showConfirmExit(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return MyAlertDialog(
          title: Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  VirusMapBRIcons.logout,
                  color: VirusMapBRTheme.color(context, "text1"),
                  size: 24.0,
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Text("Encerrar Sessão"),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Deseja encerrar sua sessão?"),
            ],
          ),
          actions: [
            FlatButton(
              child: Text("SIM"),
              onPressed: () async {
                await session.end();
                onConfirmed();
              },
            ),
            FlatButton(
              child: Text("NÃO"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
