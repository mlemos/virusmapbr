import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/stats_components.dart';
import 'package:virusmapbr/components/user_info_bar_dash.dart';
import 'package:virusmapbr/components/wp_latest_news.dart';
import 'package:virusmapbr/providers/navigation_provider.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/themes/themes.dart';

// Builds the Dashboard.
// This is the home screen of the logged user.
// The key screen of the app.

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
          UserInfoBarDash(),
          _buildCallToAction(context),
          _buildBottomSheet(context),
        ],
      ),
    );
  }

  // Builds the call to action buttons to ask about the user health status.
  Widget _buildCallToAction(context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Como você está se sentindo?",
                    style: Theme.of(context).textTheme.subtitle2.merge(
                        TextStyle(color: VirusMapBRTheme.color(context, "white"))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlineButton(
                            padding: EdgeInsets.all(10),
                            onPressed: () {
                              _showModalSheet(context);
                            },
                            child: Text(
                              "😄 Estou Bem",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .merge(TextStyle(
                                      color:
                                          VirusMapBRTheme.color(context, "white"))),
                            ),
                            borderSide: BorderSide(
                              color: VirusMapBRTheme.color(context, "white"),
                            ),
                            shape: StadiumBorder(),
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: OutlineButton(
                            padding: EdgeInsets.all(10),
                            onPressed: () {
                              navigationProvider.setTab(1);
                            },
                            child: Text(
                              "🤒 Estou Mal",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .merge(TextStyle(
                                      color:
                                          VirusMapBRTheme.color(context, "white"))),
                            ),
                            borderSide: BorderSide(
                              color: VirusMapBRTheme.color(context, "white"),
                            ),
                            shape: StadiumBorder(),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the modal with "felling ok" information.
  Future<void> _showModalSheet(BuildContext context) async {
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: 10,
                ),
              ),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    decoration: BoxDecoration(
                      color: VirusMapBRTheme.color(context, "modal"),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black38, blurRadius: 10)
                      ],
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Que ótimo! 😊",
                                  style: Theme.of(context).textTheme.headline2),
                              Container(
                                height: 32.0,
                                width: 32.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color:
                                      VirusMapBRTheme.color(context, "highlight"),
                                ),
                                child: Center(
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    color: VirusMapBRTheme.color(context, "text3"),
                                    icon: Icon(VirusMapBRIcons.exit),
                                    onPressed: () {
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Text(
                              "Para continuar protegendo você e sua família, siga as dicas abaixo:",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .merge(TextStyle(
                                      color: VirusMapBRTheme.color(
                                          context, "text2")))),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              Icon(
                                VirusMapBRIcons.okay,
                                color: VirusMapBRTheme.color(context, "text2"),
                                size: 16.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                  "Lave as mãos com água e sabão por 20 segundos.",
                                  style: Theme.of(context).textTheme.caption
                                    ..merge(TextStyle(
                                        color: VirusMapBRTheme.color(
                                            context, "text2"))))
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(
                                VirusMapBRIcons.okay,
                                color: VirusMapBRTheme.color(context, "text2"),
                                size: 16.0,
                              ),
                              SizedBox(width: 8.0),
                              Text("Ao tossir ou espirrar, utilize o cotovelo.",
                                  style: Theme.of(context).textTheme.caption
                                    ..merge(TextStyle(
                                        color: VirusMapBRTheme.color(
                                            context, "text2"))))
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(
                                VirusMapBRIcons.okay,
                                color: VirusMapBRTheme.color(context, "text2"),
                                size: 16.0,
                              ),
                              SizedBox(width: 8.0),
                              Text("Mantenha uma distância segura das pessoas.",
                                  style: Theme.of(context).textTheme.caption
                                    ..merge(TextStyle(
                                        color: VirusMapBRTheme.color(
                                            context, "text2"))))
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(
                                VirusMapBRIcons.okay,
                                color: VirusMapBRTheme.color(context, "text2"),
                                size: 16.0,
                              ),
                              SizedBox(width: 8.0),
                              Text("Higienize com frequência o celular.",
                                  style: Theme.of(context).textTheme.caption
                                    ..merge(TextStyle(
                                        color: VirusMapBRTheme.color(
                                            context, "text2"))))
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(
                                VirusMapBRIcons.okay,
                                color: VirusMapBRTheme.color(context, "text2"),
                                size: 16.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                  "Evite aglomerações, se puder, fique em casa.",
                                  style: Theme.of(context).textTheme.caption
                                    ..merge(TextStyle(
                                        color: VirusMapBRTheme.color(
                                            context, "text2"))))
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(
                                VirusMapBRIcons.okay,
                                color: VirusMapBRTheme.color(context, "text2"),
                                size: 16.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                  "Se tiver que sair, use máscara e dobre a atenção.",
                                  style: Theme.of(context).textTheme.caption
                                    ..merge(TextStyle(
                                        color: VirusMapBRTheme.color(
                                            context, "text2"))))
                            ],
                          ),
                          SizedBox(height: 24.0),
                          Container(
                            padding:
                                EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
                            height: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: VirusMapBRTheme.color(context, "modal"),
                              boxShadow: [
                                BoxShadow(color: Colors.black38, blurRadius: 10)
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 48.0,
                                  width: 48.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: VirusMapBRTheme.color(context, "primary")
                                        .withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: Icon(VirusMapBRIcons.alert_triangle,
                                        color: VirusMapBRTheme.color(
                                            context, "alert")),
                                  ),
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                      children: [
                                        TextSpan(
                                          text:
                                              "Caso tenha algum sintoma, ligue para o Disque Saúde 136, e não esqueça de ",
                                        ),
                                        TextSpan(
                                          text:
                                              "atualizar seu formulário de saúde",
                                          style: TextStyle(color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pop(context);
                                              navigationProvider.setTab(1);
                                            },
                                        ),
                                        TextSpan(text: ".")
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.0),
                          Container(
                            height: 56.0,
                            child: Row(
                              children: [
                                Expanded(
                                  child: RaisedButton(
                                    elevation: 8.0,
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))),
                                    child: Center(
                                        child: Text(
                                      "Entendi",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .merge(TextStyle(
                                              color: VirusMapBRTheme.color(
                                                  context, "white"))),
                                    )),
                                    onPressed: () {
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  // Builds the bottom sheet.
  Widget _buildBottomSheet(context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
          color: Theme.of(context).backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
        ),
        padding: EdgeInsets.fromLTRB(0, 24.0, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkStats(),
            SizedBox(height: 16.0),
            _buildRecentNews(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentNews(context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Últimas notícias",
                    style: Theme.of(context).textTheme.headline4),
                RaisedButton(
                  elevation: 0,
                  padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  color: VirusMapBRTheme.color(context, "highlight"),
                  child: Text("Ver mais"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  onPressed: () {
                    Navigator.pushNamed(context, "news");
                  },
                )
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: WPLatestNews(),
            ),
          ],
        ),
      ),
    );
  }
}
