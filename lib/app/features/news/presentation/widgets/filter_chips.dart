import 'package:cryptosight/app/features/news/data/models/news_filter_model.dart';
import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  const FilterChips({super.key, required this.onFilterChanged});
  final Function(String) onFilterChanged;

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  final List<String> filters =
      NewsFilterKind.values.map((e) => e.toString()).toList();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final String filter = filters[index];
          return ChoiceChip(
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
            selectedColor: Colors.red.shade300,
            labelStyle: TextStyle(
              color: _selectedIndex == index ? Colors.black : Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: filters.length,
      ),
    );
  }
}
