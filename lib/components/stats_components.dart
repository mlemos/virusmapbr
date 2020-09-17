import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:virusmapbr/themes/themes.dart';

class NetworkStats extends StatefulWidget {
  @override
  _NetworkStatsState createState() => _NetworkStatsState();
}

class _NetworkStatsState extends State<NetworkStats> {
  int _numPages = 2;
  int _currentPage = 0;
  final PageController _controller = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.doc("stats/dashboard").snapshots(),
      builder: (context, snapshot) {
        String updatedDate = "Carregando dados...";
        if (snapshot.hasData) {
          Timestamp updatedAt = snapshot.data.data()["updatedAt"] ?? null;
          if (updatedAt != null) {
            updatedDate = "Atualizado em " +
                Jiffy(snapshot.data.data()["updatedAt"].toDate())
                    .format("d/MMM/y [às] H:mm[h]");
          } else {
            updatedDate = "Carregando dados...";
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, updatedDate),
            SizedBox(height: 16.0),
            _buildPageView(context, _controller, snapshot),
            SizedBox(height: 8.0),
            _buildControls(),
          ],
        );
      },
    );
  }

  Widget _buildPageView(BuildContext context, controller,
      AsyncSnapshot<DocumentSnapshot> snapshot) {
    int totalUsers,
        totalSuspects,
        totalConfirmed,
        totalUnknown,
        totalRecovered,
        totalImmune;
    if (snapshot.hasData) {
      var dashboardData = snapshot.data.data();
      totalUsers = dashboardData["totalUsers"] ?? null;
      totalSuspects = dashboardData["totalSuspect"] ?? null;
      totalConfirmed = dashboardData["totalConfirmed"] ?? null;
      totalUnknown = dashboardData["totalUnknown"] ?? null;
      totalRecovered = dashboardData["totalRecovered"] ?? null;
      totalImmune = dashboardData["totalImmune"] ?? null;
    }
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PageView(
        controller: controller,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          buildStatsCards(
            context,
            totalUsers,
            totalSuspects,
            totalConfirmed,
          ),
          buildExtraStatsCards(
            context,
            totalRecovered,
            totalImmune,
            totalUnknown,
          )
        ],
      ),
    );
  }

  Widget _buildControls() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      ),
    );
  }

  // Builds a single page indicator
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: 4.0,
      width: isActive ? 12.0 : 4.0,
      decoration: BoxDecoration(
        color: isActive
            ? VirusMapBRTheme.color(context, "primary")
            : VirusMapBRTheme.color(context, "primary").withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String updatedDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: <Widget>[
              Text("Acompanhamento da rede",
                  style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 4.0),
              Text(updatedDate, style: Theme.of(context).textTheme.caption)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStatsCards(BuildContext context, int totalUsers,
      int totalSuspects, int totalConfirmed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 4),
        buildCard(context, "Cadastros", "accent", totalUsers),
        SizedBox(width: 8),
        buildCard(context, "Suspeitos", "alert", totalSuspects),
        SizedBox(width: 8),
        buildCard(context, "Confirmados", "error", totalConfirmed),
        SizedBox(width: 4),
      ],
    );
  }

  Widget buildExtraStatsCards(BuildContext context, int totalRecovered,
      int totalImmune, int totalUnknown) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 4),
        buildCard(context, "Recuperados", "success", totalRecovered),
        SizedBox(width: 8),
        buildCard(context, "Imunes", "blue", totalImmune),
        SizedBox(width: 8),
        buildCard(context, "Sem dados", "text1", totalUnknown),
        SizedBox(width: 4),
      ],
    );
  }

  Widget buildCard(
      BuildContext context, String title, String color, int value) {
    final numberFormat = NumberFormat.compact(locale: "pt");
    String valueText = (value != null) ? numberFormat.format(value) : null;
    return Expanded(
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: VirusMapBRTheme.color(context, color).withOpacity(0.1),
        ),
        padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.caption.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, color)))),
            SizedBox(height: 2.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  (value != null)
                      ? Text(
                          valueText,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.headline2,
                        )
                      : Expanded(
                          child: Container(
                            height: 20,
                            child: LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    VirusMapBRTheme.color(context, color)
                                        .withOpacity(0.3))),
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
}
