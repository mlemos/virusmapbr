import 'package:flutter/material.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

class NewsProvider extends ChangeNotifier {
  final wp.WordPress wordPress = wp.WordPress(
    baseUrl: 'https://virusmapbr.org',
  );

  List<wp.Post> latest = [];
  List<wp.Post> highlights = [];

  // Getters and Setters

  // Constructor
  NewsProvider() {
    Logger.magenta("NewsProvider >> Instance created!");
  }

  // Loads the HealthData from SharedPreferences or Firestore.
  Future<bool> load() async {
    Logger.magenta("NewsProvider >> Loading posts from Wordpress...");
    if (latest.isEmpty) {
      latest = await _fetchPosts();
      _filerHighlights();
      Logger.magenta("NewsProvider >> .. posts loaded.");
    } else {
      Logger.magenta("NewsProvider >> Already loaded. Ignoring...");
    }
    return true;
  }

  // Fetchs posts from Wordpress.
  Future<List<wp.Post>> _fetchPosts() async {
    Logger.magenta("NewsProvider >> Fetching Wordpress posts...");
    List<wp.Post> posts = await wordPress.fetchPosts(
      postParams: wp.ParamsPostList(
        context: wp.WordPressContext.view,
        pageNum: 1,
        perPage: 24,
        includeCategories: [39],
        //includeTags: [50],
      ),
      fetchFeaturedMedia: true,
    );
    Logger.magenta("NewsProvider >> .. ${posts.length} posts loaded");
    return posts;
  }

  // Filters the highlighted posts in a separate variable.
  void _filerHighlights() {
    for (var post in latest) {
      if (post.tagIDs.contains(50)) {
        highlights.add(post);
      }
    }
  }
}
