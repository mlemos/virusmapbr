import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:virusmapbr/components/help_entries.dart';
import 'package:virusmapbr/themes/themes.dart';

class DashHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(
        VirusMapBRTheme.color(context, "surface"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);

    return Scaffold(
      backgroundColor: VirusMapBRTheme.color(context, "surface"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildBottomSheet(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 24.0),
            child: Text(
              "Tire suas dúvidas 🤔",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheet(context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                color: Theme.of(context).backgroundColor,
                boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
              ),
              padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
              child: HelpEntries(),
            ),
          ),
        ],
      ),
    );
  }
}
