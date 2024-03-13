import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class ChartDataTypeSelector extends StatelessWidget {
  const ChartDataTypeSelector({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelectionUpdated,
  });

  final List<String> labels;
  final int selectedIndex;
  final Function(int) onSelectionUpdated;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: ScreenConfig.scaledWidth(0.03),
      children: List<Widget>.generate(
        labels.length,
        (index) {
          bool isSelected = selectedIndex == index;
          return ChoiceChip(
            showCheckmark: false,
            padding: ScreenConfig.horizontalDynamicPadding(0.01),
            labelPadding: ScreenConfig.horizontalDynamicPadding(0.04),
            label: Text(
              labels[index],
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontSize: ScreenConfig.scaledFontSize(0.75),
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              onSelectionUpdated(index);
            },
            backgroundColor: Colors.white.withOpacity(0.1),
            selectedColor: Colors.amber[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.transparent),
            ),
          );
        },
      ),
    );
  }
}
