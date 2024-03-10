import 'package:cryptosight/app/features/news/data/models/news_model.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class CurrencySelectionChips extends StatefulWidget {
  const CurrencySelectionChips({super.key, required this.onSelectionChanged});
  final Function(List<String>) onSelectionChanged;

  @override
  State<CurrencySelectionChips> createState() => _CurrencySelectionChipsState();
}

class _CurrencySelectionChipsState extends State<CurrencySelectionChips> {
  final List<String> _selectedCurrencies = [];

  bool isSelected(String currency) => _selectedCurrencies.contains(currency);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenConfig.scaledHeight(0.04),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Currency.currencies.length,
        itemBuilder: (context, index) {
          final currency = Currency.currencies[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? ScreenConfig.scaledWidth(0.01) : 0,
            ),
            child: ChoiceChip(
              label: Text(currency),
              selected: _selectedCurrencies.contains(currency),
              onSelected: (bool selected) {
                setState(() {
                  selected
                      ? _selectedCurrencies.add(currency)
                      : _selectedCurrencies.remove(currency);
                });
                widget.onSelectionChanged(_selectedCurrencies);
              },
              selectedColor: Colors.amber.shade600,
              checkmarkColor: Colors.black,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: ScreenConfig.scaledFontSize(0.8),
                color: isSelected(currency) ? Colors.black : Colors.white,
              ),
              labelPadding: ScreenConfig.horizontalDynamicPadding(0.01),
              padding:
                  ScreenConfig.symmetricDynamicPadding(0.01, 0.002).copyWith(
                bottom: ScreenConfig.scaledHeight(0.004),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) =>
            SizedBox(width: ScreenConfig.scaledWidth(0.005)),
      ),
    );
  }
}
