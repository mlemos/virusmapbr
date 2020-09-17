import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/components/wp_highlighted_news.dart';
import 'package:virusmapbr/components/wp_latest_news.dart';
import 'package:virusmapbr/themes/themes.dart';

// Presents the news page of the app.
// A carrousell of highlighted news and a cronological list of news.
// News are retrieved from Firebase Firestore.

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(
        VirusMapBRTheme.color(context, "background"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        VirusMapBRTheme.isDark(context));
    return Scaffold(
      backgroundColor: VirusMapBRTheme.color(context, "background"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExitButton(),
              SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text("Acompanhe as notícias",
                    style: Theme.of(context).textTheme.headline1.merge(
                        TextStyle(color: VirusMapBRTheme.color(context, "text1")))),
              ),
              SizedBox(height: 2.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text("Confira informações reais sobre a Covid-19.",
                    style: Theme.of(context).textTheme.bodyText2.merge(
                        TextStyle(color: VirusMapBRTheme.color(context, "text2")))),
              ),
              SizedBox(height: 24.0),
              WPHighlightedNews(),
              SizedBox(height: 32.0),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: WPLatestNews(),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
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
                icon: Icon(VirusMapBRIcons.return_icon),
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
    );
  }
}
