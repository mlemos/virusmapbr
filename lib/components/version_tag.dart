import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:virusmapbr/themes/themes.dart';

class VersionTag extends StatelessWidget {
  final Color color;

  VersionTag({this.color, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getVersion(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            "Versão ${snapshot.data} ",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption.merge(
                  TextStyle(
                    color: color ?? VirusMapBRTheme.color(context, "text3"),
                  ),
                ),
          );
        } else {
          return Text(
            "Carregando versão... ",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption.merge(
                  TextStyle(
                    color: color ?? VirusMapBRTheme.color(context, "text3"),
                  ),
                ),
          );
        }
      },
    );
  }

  Future<String> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String build = packageInfo.buildNumber;
    String tag = version + "+" + build;
    if (!kReleaseMode) {
      tag = tag + " (debug)";
    }

    return tag;
  }
}
