import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:jiffy/jiffy.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

class NewsItem extends StatelessWidget {
  final wp.Post post;

  NewsItem(this.post);

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return Scaffold(
      body: Container(
        color: VirusMapBRTheme.color(context, "background"),
        child: Stack(
          children: [
            buildHeader(context),
            buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    String imageUrl = post.featuredMedia.sourceUrl ?? "";
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(
        //height: 23.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: VirusMapBRTheme.color(context, "disabled"),
                width: 56.0,
                height: 64.0,
                child: Icon(
                  VirusMapBRIcons.image,
                  size: 32.0,
                  color: VirusMapBRTheme.color(context, "text4"),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: VirusMapBRTheme.color(context, "disabled"),
                width: 56.0,
                height: 64.0,
                child: Icon(
                  VirusMapBRIcons.image,
                  size: 32.0,
                  color: Theme.of(context).errorColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 24.0),
              child: Column(
                children: [
                  _buildExitButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExitButton(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32.0,
          width: 32.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: VirusMapBRTheme.color(context, "black").withOpacity(0.4),
            //color: VirusMapBRTheme.color(context, "white").withOpacity(0.2),
          ),
          child: Center(
            child: IconButton(
              padding: EdgeInsets.all(0),
              //color: VirusMapBRTheme.color(context, "text3"),
              color: VirusMapBRTheme.color(context, "white"),
              icon: Icon(VirusMapBRIcons.return_icon),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    String title = post.title.rendered.toString() ?? "";
    String body = post.content.rendered.toString() ?? "";
    DateTime publishedAt = DateTime.parse(post.date);
    String publishedDate = "";
    if (publishedAt != null) {
      publishedDate = "Publicada em " +
          Jiffy(publishedAt)
              .format("d/MMM/y [às] H:mm[h]");
    } else {
      publishedDate = "";
    }

    return DraggableScrollableSheet(
      minChildSize: 0.75,
      initialChildSize: 0.75,
      maxChildSize: 1,
      builder: (context, ScrollController scrollController) {
        return Container(
          //color: Colors.green,
          padding: const EdgeInsets.only(top: 96),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              color: VirusMapBRTheme.color(context, "background"),
              boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
            ),
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Text(
                  publishedDate,
                  style: Theme.of(context).textTheme.caption.merge(
                      TextStyle(color: VirusMapBRTheme.color(context, "text3"))),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.0),
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
                      data: body,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
