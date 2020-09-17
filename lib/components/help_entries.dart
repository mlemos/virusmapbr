import 'package:flutter/material.dart';
import 'package:virusmapbr/components/help_entries_list.dart';
import 'help_categories_filter.dart';

class HelpEntries extends StatefulWidget {
  @override
  _HelpEntriesState createState() => _HelpEntriesState();
}

class _HelpEntriesState extends State<HelpEntries> {
  int _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HelpCategoriesFilter(
            _selectedCategory,
            onUpdateNeeded: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          SizedBox(height: 24.0),
          HelpEntriesList(_selectedCategory),
        ],
      ),
    );
  }
}
