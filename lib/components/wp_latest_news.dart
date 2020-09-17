import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/screens/news_item.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:html/parser.dart';

class WPLatestNews extends StatelessWidget {
  final wp.WordPress wordPress = wp.WordPress(
    baseUrl: 'https://virusmapbr.org',
  );

  _fetchPosts() {
    Future<List<wp.Post>> posts = wordPress.fetchPosts(
      postParams: wp.ParamsPostList(
        context: wp.WordPressContext.view,
        pageNum: 1,
        perPage: 12,
        includeCategories: [39],
      ),
      fetchFeaturedMedia: true,
    );
    return posts;
  }

  _getPostImageUrl(wp.Post post) {
    if (post.featuredMedia == null) {
      return null;
    }
    return post.featuredMedia.sourceUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: _fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Container();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return _renderPost(context, snapshot.data[index]);
          },
          separatorBuilder: (context, index) => _separator(context),
        );
      },
    ));
  }

  Widget _separator(context) {
    return Column(children: [
      SizedBox(
        height: 16.0,
      ),
      Divider(
        color: VirusMapBRTheme.color(context, "disabled"),
      ),
      SizedBox(
        height: 16.0,
      )
    ]);
  }

  Widget _renderPost(BuildContext context, wp.Post post) {
    String title = post.title.rendered.toString() ?? "";
    String summary = _parseHtmlString(post.excerpt.rendered.toString());
    String imageUrl = _getPostImageUrl(post) ?? "";
    DateTime publishedAt = DateTime.parse(post.date);
    String publishedDate = "";
    if (publishedAt != null) {
      publishedDate = Jiffy(publishedAt).fromNow();
    } else {
      publishedDate = "";
    }
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => NewsItem(post))),
      child: Container(
        height: 64.0,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: CachedNetworkImage(
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
                imageUrl: imageUrl,
                width: 56.0,
                height: 64.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.subtitle2,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        publishedDate,
                        style: Theme.of(context).textTheme.caption.merge(
                            TextStyle(
                                color: VirusMapBRTheme.color(context, "text4"))),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    summary,
                    style: Theme.of(context).textTheme.caption.merge(
                        TextStyle(color: VirusMapBRTheme.color(context, "text3"))),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    if ((htmlString != null) && (htmlString.length > 0)) {
      var document = parse(htmlString);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    } else {
      return "";
    }
  }
}
