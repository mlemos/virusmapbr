import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/screens/help_item.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

class HelpEntriesList extends StatelessWidget {
  final int selectedCategory;

  final _categoriesNames = {
    42: "Sobre o App",
    43: "Usando o App",
    44: "Privacidade e Segurança",
    45: "Dicas de Saúde",
    46: "Para Emergências",
    47: "Resolvendo Problemas",
  };

  final wp.WordPress wordPress = wp.WordPress(
    baseUrl: 'https://virusmapbr.org',
  );

  _fetchPosts(int selectedCategory) {
    Future<List<wp.Post>> posts = wordPress.fetchPosts(
      postParams: wp.ParamsPostList(
        context: wp.WordPressContext.view,
        pageNum: 1,
        perPage: 30,
        includeCategories: [selectedCategory ?? 41],
      ),
      fetchFeaturedMedia: true,
    );
    return posts;
  }

  @override
  HelpEntriesList(this.selectedCategory, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: FutureBuilder(
          future: _fetchPosts(selectedCategory),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<wp.Post> posts = snapshot.data;
            return _entriesList(context, posts);
          },
        ),
      ),
    );
  }

  Widget _entriesList(BuildContext context, List<wp.Post> posts) {
    return GroupedListView(
      elements: posts,
      groupBy: (wp.Post post) {
        var categoriesId = post.categoryIDs;
        categoriesId.remove(41);
        return categoriesId[0];
      } ,
      groupSeparatorBuilder: (categoryId) => _categoryTitle(context, categoryId),
      itemBuilder: (context, post) => _helpEntry(context, post),
      order: GroupedListOrder.ASC,
    );
  }

  Widget _categoryTitle(BuildContext context, int categoryId) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
      child: Text(
        _categoriesNames[categoryId] ?? "Outros",
        style: Theme.of(context)
            .textTheme
            .headline3
            .merge(TextStyle(color: VirusMapBRTheme.color(context, "text1"))),
      ),
    );
  }

  Widget _helpEntry(BuildContext context, wp.Post post) {
    return Column(
      //color: Colors.blue[100],
      children: [
        InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => HelpItem(post))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  post.title.rendered.toString(),
                  style: Theme.of(context).textTheme.bodyText2.merge(
                      TextStyle(color: VirusMapBRTheme.color(context, "text2"))),
                ),
              ),
              Container(
                child: Icon(
                  VirusMapBRIcons.arrow_right,
                  color: VirusMapBRTheme.color(context, "text3"),
                  size: 24.0,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16.0),
        Divider(color: VirusMapBRTheme.color(context, "disabled")),
        SizedBox(height: 16.0),
      ],
    );
  }
}
