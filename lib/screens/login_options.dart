import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:virusmapbr/components/version_tag.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/screens/terms_of_use.dart';
import 'package:virusmapbr/themes/themes.dart';

// Login Options Screen
// Presents the login buttons for each authentication provider.

class LoginOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(
        VirusMapBRTheme.color(context, "surface"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    Logger.white("LoginOptions >> build()");

    return Container(
      color: VirusMapBRTheme.color(context, "modal"),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: VirusMapBRTheme.color(context, "surface"),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 16.0),
                Text(
                  "VirusMapBR",
                  style: Theme.of(context).textTheme.headline1.merge(
                        TextStyle(
                          fontWeight: FontWeight.w800,
                          color: VirusMapBRTheme.color(context, "white"),
                        ),
                      ),
                ),
                _buildLogo(context),
                VersionTag(color: VirusMapBRTheme.color(context, "white")),
                SizedBox(height: 16.0),
                _buildControls(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Expanded(
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 105.0,
              backgroundColor:
                  VirusMapBRTheme.color(context, "white").withOpacity(0.05),
              child: CircleAvatar(
                radius: 86.0,
                backgroundColor: VirusMapBRTheme.color(context, "white")
                    .withOpacity(0.1),
                child: CircleAvatar(
                  radius: 69.0,
                  backgroundColor: VirusMapBRTheme.color(context, "white")
                      .withOpacity(0.8),
                ),
              ),
            ),
            Container(
              width: 210.0,
              height: 210.0,
              child: Image.asset("assets/onboard-map-yellow.png"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 40.0),
      decoration: BoxDecoration(
        color: VirusMapBRTheme.color(context, "modal"),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -10),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _googleSignInButton(context),
                SizedBox(height: 24),
                _phoneNumberSignInButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleSignInButton(BuildContext context) {
    return Container(
      height: 56.0,
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              elevation: 8.0,
              color: VirusMapBRTheme.color(context, "modal"),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: VirusMapBRTheme.color(context, "text4"), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        image: AssetImage("assets/google_icon.png"),
                        height: 35.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        'Entrar com Google',
                        style: Theme.of(context).textTheme.headline3.merge(
                            TextStyle(
                                color: VirusMapBRTheme.color(context, "text3"))),
                      ),
                    )
                  ],
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsOfUse("google")),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _phoneNumberSignInButton(BuildContext context) {
    return Container(
      height: 56.0,
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              elevation: 8.0,
              color: VirusMapBRTheme.color(context, "modal"),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: VirusMapBRTheme.color(context, "text4"), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        image: AssetImage("assets/fone_icon.png"),
                        height: 35.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        'Entrar com telefone',
                        style: Theme.of(context).textTheme.headline3.merge(
                            TextStyle(
                                color: VirusMapBRTheme.color(context, "text3"))),
                      ),
                    )
                  ],
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsOfUse("phone")),
              ),
            ),
          )
        ],
      ),
    );
  }
}
