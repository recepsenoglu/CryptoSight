import 'package:cryptosight/app/features/news/data/models/news_model.dart';
import 'package:flutter/material.dart';

class CurrencySelectionChips extends StatefulWidget {
  const CurrencySelectionChips(
      {super.key, required this.onSelectionChanged});
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
      height: 30, // Specify an appropriate height
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Currency.currencies.length,
        itemBuilder: (context, index) {
          final currency = Currency.currencies[index];
          return ChoiceChip(
            selectedColor: Colors.amber.shade600,
            checkmarkColor: Colors.black,
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
            labelStyle: TextStyle(
              color: isSelected(currency)
                  ? Colors.black
                  : Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
            labelPadding: const EdgeInsets.symmetric(
                horizontal: 8.0), 
            padding: const EdgeInsets.symmetric(vertical: 4.0),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 4),
      ),
    );
  }
}
