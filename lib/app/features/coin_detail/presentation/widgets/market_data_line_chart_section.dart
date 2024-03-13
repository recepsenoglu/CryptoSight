import 'package:cryptosight/app/features/coin_detail/domain/notifiers/coin_detail_notifier.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MarketDataLineChartSection extends StatelessWidget {
  const MarketDataLineChartSection({
    super.key,
    required this.status,
    required this.data,
    required this.onMarketDataTypeSelectionUpdated,
    required this.onTimeIntervalSelectionUpdated,
  });

  final CoinDetailStateStatus status;
  final List<List<num>>? data;
  final Function(int) onMarketDataTypeSelectionUpdated;
  final Function(int) onTimeIntervalSelectionUpdated;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        ToggleButtonGroup(
          labels: const ['Price', 'Market Cap', 'Volume (24h)'],
          onSelectionUpdated: onMarketDataTypeSelectionUpdated,
        ),
        SizedBox(height: ScreenConfig.scaledHeight(0.01)),
        Visibility(
          visible: status == CoinDetailStateStatus.success,
          child: TimeIntervalSelector(
            labels: const [
              'All',
              '1Y',
              '6M',
              '3M',
              '1M',
              '7D',
              '1D',
            ],
            onTimeIntervalSelectionUpdated: onTimeIntervalSelectionUpdated,
          ),
        ),
        SizedBox(height: ScreenConfig.scaledHeight(0.03)),
        SizedBox(
          height: ScreenConfig.scaledHeight(0.3),
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: Colors.grey,
                    strokeWidth: 0.5,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  axisNameSize: 12,
                  drawBelowEverything: true,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: ScreenConfig.scaledFontSize(2),
                    getTitlesWidget: (value, meta) {
                      return FittedBox(
                        child: Text(
                          value.toCurrencyString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenConfig.scaledFontSize(0.7),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data
                          ?.map((e) => FlSpot(e[0].toDouble(), e[1].toDouble()))
                          .toList() ??
                      [],
                  barWidth: 1.5,
                  isCurved: true,
                  isStrokeCapRound: true,
                  color: Colors.blue.shade900,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.shade900.withOpacity(0.2),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.white,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipRoundedRadius: 10,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots
                        .map((e) => LineTooltipItem(
                              e.x.fromTimestamp(),
                              TextStyle(
                                color: Colors.grey,
                                fontSize: ScreenConfig.scaledFontSize(0.6),
                              ),
                              children: [
                                TextSpan(
                                  text: '\n\$ ${e.y.formatCoinPrice()}',
                                  // text: '\n${DateTime.fromMillisecondsSinceEpoch(e.x.toInt()).toLocal().hour}:${DateTime.fromMillisecondsSinceEpoch(e.x.toInt()).toLocal().minute}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenConfig.scaledFontSize(0.7),
                                  ),
                                ),
                              ],
                            ))
                        .toList();
                  },
                ),
                touchCallback:
                    (FlTouchEvent te, LineTouchResponse? touchResponse) {},
                handleBuiltInTouches: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TimeIntervalSelector extends StatefulWidget {
  const TimeIntervalSelector({
    super.key,
    required this.labels,
    required this.onTimeIntervalSelectionUpdated,
  });
  final List<String> labels;
  final Function(int) onTimeIntervalSelectionUpdated;

  @override
  State<TimeIntervalSelector> createState() => _TimeIntervalSelectorState();
}

class _TimeIntervalSelectorState extends State<TimeIntervalSelector> {
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenConfig.scaledHeight(0.035),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.labels.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedIndex == index;
          return Container(
            width: ScreenConfig.scaledWidth(0.115),
            padding: ScreenConfig.symmetricDynamicPadding(0.00, 0.00),
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber[700] : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onTimeIntervalSelectionUpdated(index);
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                padding: MaterialStateProperty.all(
                  ScreenConfig.horizontalDynamicPadding(0.0),
                ),
              ),
              child: FittedBox(
                child: Text(
                  widget.labels[index],
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

class ToggleButtonGroup extends StatefulWidget {
  const ToggleButtonGroup({
    super.key,
    required this.labels,
    required this.onSelectionUpdated,
  });

  final List<String> labels;
  final Function(int) onSelectionUpdated;

  @override
  State<ToggleButtonGroup> createState() => _ToggleButtonGroupState();
}

class _ToggleButtonGroupState extends State<ToggleButtonGroup> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);
    return Wrap(
      spacing: ScreenConfig.scaledWidth(0.03),
      children: List<Widget>.generate(
        widget.labels.length,
        (index) {
          bool isSelected = _selectedIndex == index;
          return ChoiceChip(
            showCheckmark: false,
            padding: ScreenConfig.horizontalDynamicPadding(0.01),
            labelPadding: ScreenConfig.horizontalDynamicPadding(0.04),
            label: Text(
              widget.labels[index],
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontSize: ScreenConfig.scaledFontSize(0.75),
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedIndex = index;
              });
              widget.onSelectionUpdated(index);
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
