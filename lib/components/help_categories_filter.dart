import 'package:flutter/material.dart';
import 'package:virusmapbr/themes/themes.dart';

class HelpCategoriesFilter extends StatefulWidget {
  final int selectedCategory;
  final void Function(int) onUpdateNeeded;

  @override
  HelpCategoriesFilter(this.selectedCategory, {this.onUpdateNeeded, Key key}) : super(key: key);

  @override
  _HelpCategoriesFilterState createState() =>
      _HelpCategoriesFilterState(selectedCategory, onUpdateNeeded);
}

class _HelpCategoriesFilterState extends State<HelpCategoriesFilter> {
  int selectedCategory;
  final void Function(int) onUpdateNeeded;

  final _categoriesColors = {
    42: "blue",
    43: "green",
    44: "yellow",
    45: "orange",
    46: "red",
    47: "purple",
  };

  final _categoriesNames = {
    42: "Sobre o App",
    43: "Usando o App",
    44: "Privacidade e Segurança",
    45: "Dicas de Saúde",
    46: "Para Emergências",
    47: "Resolvendo Problemas",
  };

  @override
  _HelpCategoriesFilterState(this.selectedCategory, this.onUpdateNeeded);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildCategoryFilterSelector(),
    );
  }

  Widget _buildCategoryFilterSelector() {
    return Container(
      height: 54,
      child: ListView.separated(
        itemCount: _categoriesColors.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, i) => SizedBox(width: 8.0),
        itemBuilder: (context, i) {
          var category = _categoriesColors.keys.toList()[i];
          return _categoryCard(
              category, _categoriesColors[category]);
        },
      ),
    );
  }

  Widget _categoryCard(int category, String color,) {
    bool isSelected = (category == selectedCategory);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCategory = null;
            isSelected = false;
          } else {
            selectedCategory = category;
          }
          if (onUpdateNeeded != null) onUpdateNeeded(selectedCategory);
        });
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: (isSelected)
              ? VirusMapBRTheme.color(context, color)
              : VirusMapBRTheme.color(context, color).withOpacity(0.25),
        ),
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  _categoriesNames[category],
                  style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(
                      color: (isSelected)
                          ? VirusMapBRTheme.color(context, "text5")
                          : VirusMapBRTheme.color(context, color))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
