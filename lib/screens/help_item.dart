import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/services/firebase_analytics.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:url_launcher/url_launcher.dart';

class HelpItem extends StatelessWidget {
  final wp.Post post;

  HelpItem(this.post);

  @override
  Widget build(BuildContext context) {
    firebaseLogEvent("help_item",
        parameters: {"title": post.title.rendered.toString()});
    return Scaffold(
      backgroundColor: VirusMapBRTheme.color(context, "surface"),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildBackButton(context),
            _buildHeader(context),
            _buildBottomSheet(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0),
      child: Row(
        children: [
          Container(
            height: 32.0,
            width: 32.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: VirusMapBRTheme.color(context, "modal").withOpacity(0.2),
            ),
            child: Center(
              child: IconButton(
                padding: EdgeInsets.all(0),
                color: VirusMapBRTheme.color(context, "white"),
                icon: Icon(VirusMapBRIcons.return_icon),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
            child: Text(
              post.title.rendered.toString(),
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
    ScrollController scrollController = ScrollController();
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
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Html(
                        onLinkTap: (href) async {
                          Logger.red("Clicked in: $href");
                          if (await canLaunch(href)) {
                            await launch(href);
                          } else {
                            Logger.red("... can't launch: $href");
                          }
                        },
                        data: post.content.rendered.toString(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
