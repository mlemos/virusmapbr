import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:virusmapbr/services/google_auth_service.dart';
import 'package:virusmapbr/helpers/logger.dart';

class TermsOfUse extends StatefulWidget {
  const TermsOfUse(
    this.platform, {
    Key key,
  }) : super(key: key);
  final String platform;
  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  bool _hasAcceptedTerms = false;
  Future<String> terms;

  @override
  void initState() {
    terms = loadTerms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(
        VirusMapBRTheme.color(context, "surface"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    Logger.white("TermosOfUse >> build()");

    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 56.0),
        child: Container(
          decoration: BoxDecoration(
            color: VirusMapBRTheme.color(context, "modal"),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Termos de Uso",
                        style: Theme.of(context).textTheme.headline2),
                    Container(
                      height: 32.0,
                      width: 32.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: VirusMapBRTheme.color(context, "highlight"),
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          color: VirusMapBRTheme.color(context, "text3"),
                          icon: Icon(VirusMapBRIcons.exit),
                          onPressed: () {
                            setState(() {
                              _hasAcceptedTerms = false;
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              termsText(context),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _hasAcceptedTerms,
                onChanged: (bool value) {
                  setState(() {
                    _hasAcceptedTerms = value;
                  });
                },
                title: Text(
                  "Li e concordo com os termos.",
                ),
              ),
              termsButton(context, widget.platform, _hasAcceptedTerms),
            ],
          ),
        ),
      ),
    );
  }

  // Loads the terms of use from asset file
  Future<String> loadTerms() async {
    return await rootBundle.loadString('assets/terms_of_use.txt');
  }

  // Builds the scrollview with the terms text
  Widget termsText(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.0, 0, 24.0, 8.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: VirusMapBRTheme.color(context, "white"),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: FutureBuilder<String>(
                  future: terms,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: LinearProgressIndicator());
                    } else {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data,
                          style: Theme.of(context).textTheme.caption.merge(
                              TextStyle(
                                  color: VirusMapBRTheme.color(context, "black"))),
                        );
                      } else {
                        return Text("Failed!");
                      }
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget termsButton(
      BuildContext context, String platform, bool hasAcceptedTerms) {
    final googleAuthService = GoogleAuthService();
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
      child: Container(
        height: 56.0,
        child: Row(
          children: [
            Expanded(
              child: RaisedButton(
                elevation: 8.0,
                color: Theme.of(context).primaryColor,
                disabledColor: VirusMapBRTheme.color(context, "disabled"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Center(
                    child: Text(
                  "Ok, vamos em frente!",
                  style: Theme.of(context).textTheme.headline3.merge(
                      TextStyle(color: VirusMapBRTheme.color(context, "white"))),
                )),
                onPressed: hasAcceptedTerms
                    ? () async {
                        if (platform == "google") {
                          var success =
                              await googleAuthService.signInWithGoogle();
                          if (success) {
                            Logger.green("TermsOfUse >> Signed with Google!");
                            Navigator.pushNamedAndRemoveUntil(context,
                                "welcome", (Route<dynamic> route) => false);
                          } else {
                            Logger.red("TermsOfUse >> Sign in with Google failed!");
                            Navigator.pop(context);
                          }
                        } else {
                          Logger.green("TermsOfUse >> Signing with Phone...");
                          Navigator.pushNamed(context, "phone_auth");
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
