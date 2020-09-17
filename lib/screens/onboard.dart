import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:virusmapbr/services/firebase_analytics.dart';
import 'package:virusmapbr/themes/themes.dart';

// Onboard Screen
// This widget builds the onboarding interface of the app for new (not logged) users.
// It presents a few screens with instruction and information about the app.
// In the last page it presents the term of use for the app and requires the user to accept them.
// The user cannot move forward if he hast not accepted the terms.

class Onboard extends StatefulWidget {
  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  static List<Map> _pagesContent = [
    {
      "title": "Visualize a pandemia em tempo real",
      "desc":
          "Tenha acesso ao mapa de casos, com suspeitos, confirmados e recuperados.",
      "image": "assets/onboard-map-yellow.png"
    },
    {
      "title": "Avalie seu estado de saúde e ajude outras pessoas",
      "desc":
          "Responda o formulário sobre seu estado de saúde e ajude a entendermos a propagação da pandemia.",
      "image": "assets/onboard-health.png"
    },
    {
      "title": "Acompanhe dicas e notícias",
      "desc":
          "Confira as últimas notícias sobre o novo coronavírus e acesse dicas de como se proteger.",
      "image": "assets/onboard-news.png"
    },
    {
      "title": "Total segurança e privacidade dos seus dados",
      "desc":
          "Garantimos que nenhuma informação será compartilhada de forma identificada.",
      "image": "assets/onboard-privacy-purple.png"
    },
  ];
  int _numPages = _pagesContent.length;
  int _currentPage = 0;
  final PageController _controller = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(
        VirusMapBRTheme.color(context, "surface"));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    if (_currentPage == 0) analytics.logTutorialBegin();
    if (_currentPage == _numPages - 1) analytics.logTutorialComplete();

    return Material(
      child: Container(
        color: VirusMapBRTheme.color(context, "surface"),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 32.0),
            color: VirusMapBRTheme.color(context, "surface"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildPageView(_controller)),
                _buildControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the PageView widget with the onboarding apges
  PageView _buildPageView(controller) {
    return PageView(
      controller: controller,
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page;
        });
      },
      children: [
        for (int i = 0; i < _numPages; i++) _buildOnboardPage(i),
      ],
    );
  }

  // Builds the page indicator and navigation controls
  Widget _buildControls() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: list),
        Container(
          height: 56.0,
          child: RaisedButton(
              color: VirusMapBRTheme.color(context, "surface"),
              padding: EdgeInsets.symmetric(horizontal: 56.0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: VirusMapBRTheme.color(context, "white"), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Text(
                "Próximo",
                style: Theme.of(context).textTheme.headline3.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "white"))),
              ),
              onPressed: () {
                if (_currentPage < (_numPages - 1)) {
                  _controller.nextPage(
                      duration: Duration(microseconds: 1500),
                      curve: Curves.ease);
                } else {
                  Navigator.pushNamed(context, "login");
                }
              }),
        )
      ],
    );
  }

  // Builds a single page indicator
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? VirusMapBRTheme.color(context, "white")
            : VirusMapBRTheme.color(context, "white").withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  // Builds a standard onboard page (the terms page is different)
  Widget _buildOnboardPage(int index) {
    Map pageContent = _pagesContent[index];
    var title = pageContent["title"];
    var desc = pageContent["desc"];
    var image = pageContent["image"];

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          Text(
            "VirusMapBR",
            style: Theme.of(context).textTheme.headline1.merge(
                  TextStyle(
                    fontWeight: FontWeight.w800,
                    color: VirusMapBRTheme.color(context, "white"),
                  ),
                ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 105.0,
                  backgroundColor:
                      VirusMapBRTheme.color(context, "white").withOpacity(0.05),
                  child: CircleAvatar(
                    radius: 86.0,
                    backgroundColor:
                        VirusMapBRTheme.color(context, "white").withOpacity(0.1),
                    child: CircleAvatar(
                      radius: 69.0,
                      backgroundColor:
                          VirusMapBRTheme.color(context, "white").withOpacity(0.8),
                    ),
                  ),
                ),
                Container(
                  width: 210.0,
                  height: 210.0,
                  child: Image.asset(image),
                )
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline2.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "white"))),
              ),
              SizedBox(height: 12.0),
              Text(
                desc,
                style: Theme.of(context).textTheme.bodyText2.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "white"))),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ],
      ),
    );
  }

  // Builds the individual onboarding pages

}
