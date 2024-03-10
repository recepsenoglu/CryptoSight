import 'package:cryptosight/app/features/news/data/models/news_filter_model.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  const FilterChips({super.key, required this.onFilterChanged});
  final Function(String) onFilterChanged;

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  final List<String> filters =
      NewsFilterKind.values.map((e) => e.name).toList();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenConfig.scaledHeight(0.05),
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final String filter = filters[index];
          return Padding(
            padding: EdgeInsets.only(
                left: index == 0 ? ScreenConfig.scaledWidth(0.02) : 0),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text(filter.toUpperCase()),
              selected: _selectedIndex == index,
              onSelected: (bool selected) {
                if (_selectedIndex != index) {
                  setState(() {
                    _selectedIndex = selected ? index : 0;
                  });
                  widget.onFilterChanged(filter);
                }
              },
              selectedColor: Colors.white,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenConfig.scaledFontSize(0.8),
                color: _selectedIndex == index ? Colors.black : Colors.white,
              ),
              labelPadding: ScreenConfig.horizontalDynamicPadding(0.01),
            ),
          );
        },
        separatorBuilder: (context, index) =>
            SizedBox(width: ScreenConfig.scaledWidth(0.02)),
        itemCount: filters.length,
      ),
    );
  }
}
