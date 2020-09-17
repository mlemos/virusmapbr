import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/providers/navigation_provider.dart';
import 'package:virusmapbr/providers/location_permissions_provider.dart';
import 'package:virusmapbr/providers/session_provider.dart';
import 'package:virusmapbr/themes/themes.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(
        VirusMapBRTheme.color(context, "surface"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);

    final _sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final _permissionsProvider = Provider.of<LocationPermissionsProvider>(context, listen: false);
    _permissionsProvider.requestPermissions();

    return Material(
      child: Container(
        color: VirusMapBRTheme.color(context, "surface"),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
            color: VirusMapBRTheme.color(context, "surface"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 48.0),
                          child: CircleAvatar(
                            radius: 105.0,
                            backgroundColor: VirusMapBRTheme.color(context, "white")
                                .withOpacity(0.05),
                            child: CircleAvatar(
                              radius: 86.0,
                              backgroundColor: VirusMapBRTheme.color(context, "white")
                                  .withOpacity(0.10),
                              child: CircleAvatar(
                                radius: 69.0,
                                backgroundColor:
                                    VirusMapBRTheme.color(context, "white")
                                        .withOpacity(0.50),
                                child: Image.asset("assets/celebration.png",
                                    height: 110.0, width: 110.0),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                                future: _sessionProvider.load(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var session = _sessionProvider.session;
                                    var userName = session.displayName;

                                    return Text(
                                      "Pronto, $userName!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .merge(TextStyle(
                                              color: VirusMapBRTheme.color(
                                                  context, "white"))),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }),
                            SizedBox(height: 12.0),
                            Text(
                              "Agora você pode acompanhar em tempo real o mapa com os casos monitorados, mas não esqueça de preencher seu formulário de saúde.",
                              style: Theme.of(context).textTheme.bodyText2.merge(
                                  TextStyle(
                                      color:
                                          VirusMapBRTheme.color(context, "white"))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 56.0,
                  child: RaisedButton(
                      elevation: 0,
                      color: VirusMapBRTheme.color(context, "surface"),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: VirusMapBRTheme.color(context, "white"),
                              width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Text(
                        "Preencher formulário",
                        style: Theme.of(context).textTheme.headline3.merge(
                            TextStyle(
                                color: VirusMapBRTheme.color(context, "white"))),
                      ),
                      onPressed: () {
                        final navigationProvider =
                            Provider.of<NavigationProvider>(context, listen: false);
                        navigationProvider.setTab(1, false);
                        Navigator.popAndPushNamed(context, "logged");
                      }),
                ),
                SizedBox(height: 16.0),
                FlatButton(
                  child: Text(
                    "Preencher depois",
                    style: Theme.of(context).textTheme.subtitle2.merge(
                        TextStyle(color: VirusMapBRTheme.color(context, "white"))),
                  ),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "logged");
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
