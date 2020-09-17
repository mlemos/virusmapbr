import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/providers/news_provider.dart';
import 'package:virusmapbr/screens/news_item.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:html/parser.dart';

class WPHighlightedNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NewsProvider newsProvider = Provider.of<NewsProvider>(context);
    return FutureBuilder<Object>(
      future: newsProvider.load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 190.0,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data != true) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 190.0,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          height: 190.0,
          child: WPHighlights(),
        );
      },
    );
  }
}

class WPHighlights extends StatefulWidget {
  @override
  _WPHighlightsState createState() => _WPHighlightsState();
}

class _WPHighlightsState extends State<WPHighlights> {
  NewsProvider _newsProvider;
  int _currentPage = 0;
  int _numPages;
  PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    _newsProvider = Provider.of<NewsProvider>(context);
    _numPages = _newsProvider.highlights.length ?? 0;

    return Column(
      children: [
        _buildPageView(_controller, _newsProvider.highlights),
        SizedBox(height: 8.0),
        _buildControls(),
      ],
    );
  }

  Widget _buildPageView(controller, posts) {
    return Expanded(
      child: PageView(
        controller: controller,
        onPageChanged: (int page) {
          Logger.yellow("Page changed...");
          _currentPage = page;
          Logger.yellow("_currentPage : $_currentPage");
          setState(() {});
        },
        children: [
          for (int i = 0; i < _numPages; i++) _buildNewsCard(context, posts[i]),
        ],
      ),
    );
  }

  _getPostImageUrl(wp.Post post) {
    if (post.featuredMedia == null) {
      return null;
    }
    return post.featuredMedia.sourceUrl;
  }

  Widget _buildNewsCard(BuildContext context, wp.Post post) {
    String title = post.title.rendered.toString() ?? "";
    String body = _parseHtmlString(post.excerpt.rendered.toString());
    String imageUrl = _getPostImageUrl(post) ?? "";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewsItem(post))),
        child: Container(      
          decoration: BoxDecoration(            
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(12.0),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
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
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(.9),
                    ],
                    stops: [0.3,1],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline2.merge(
                            TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2.0,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2.0,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
