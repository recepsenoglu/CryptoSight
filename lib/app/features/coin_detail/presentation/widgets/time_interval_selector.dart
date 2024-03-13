import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class TimeIntervalSelector extends StatelessWidget {
  const TimeIntervalSelector({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTimeIntervalSelectionUpdated,
  });
  final int selectedIndex;
  final Function(int) onTimeIntervalSelectionUpdated;

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenConfig.scaledHeight(0.035),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return Container(
            width: ScreenConfig.scaledWidth(0.115),
            padding: ScreenConfig.symmetricDynamicPadding(0.00, 0.00),
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber[700] : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                onTimeIntervalSelectionUpdated(index);
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                padding: MaterialStateProperty.all(
                  ScreenConfig.horizontalDynamicPadding(0.0),
                ),
              ),
              child: FittedBox(
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontSize: ScreenConfig.scaledFontSize(0.75),
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: ScreenConfig.scaledWidth(0.02));
        },
      ),
    );
  }
}
