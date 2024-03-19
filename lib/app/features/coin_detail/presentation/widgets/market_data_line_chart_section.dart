import 'package:cryptosight/app/features/coin_detail/data/models/market_chart_data_model.dart';
import 'package:cryptosight/app/features/coin_detail/domain/notifiers/market_chart_notifier.dart';
import 'package:cryptosight/app/features/coin_detail/presentation/widgets/chart_data_type_selector.dart';
import 'package:cryptosight/app/features/coin_detail/presentation/widgets/time_interval_selector.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketDataLineChartSection extends StatelessWidget {
  const MarketDataLineChartSection({
    super.key,
    required this.marketChartState,
    required this.onMarketDataTypeSelectionUpdated,
    required this.onTimeIntervalSelectionUpdated,
    required this.onRetry,
  });

  final MarketChartState marketChartState;
  final Function(MarketChartDataType) onMarketDataTypeSelectionUpdated;
  final Function(MarketChartTimeInterval) onTimeIntervalSelectionUpdated;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (marketChartState.status == MarketChartStateStatus.initial) {
      return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.amber[700])),
      );
    }

    if (marketChartState.status == MarketChartStateStatus.error) {
      return ErrorWidget(onRetry: onRetry);
    }

    return Column(
      children: [
        ChartDataTypeSelector(
          labels: const ['Price', 'Market Cap', 'Volume (24h)'],
          selectedIndex: marketChartState.marketChart?.type.index ?? 0,
          onSelectionUpdated: (int index) {
            onMarketDataTypeSelectionUpdated(MarketChartDataType.values[index]);
          },
        ),
        SizedBox(height: ScreenConfig.scaledHeight(0.01)),
        TimeIntervalSelector(
          labels: const ['All', '1Y', '6M', '3M', '1M', '7D', '1D'],
          selectedIndex: marketChartState.marketChart?.timeInterval.index ?? 4,
          onTimeIntervalSelectionUpdated: (int index) {
            onTimeIntervalSelectionUpdated(
                MarketChartTimeInterval.values[index]);
          },
        ),
        SizedBox(height: ScreenConfig.scaledHeight(0.03)),
        Stack(
          alignment: Alignment.center,
          children: [
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
                      spots: marketChartState.marketChart?.marketChartData
                              .getData(
                                  MarketChartDataType.values[marketChartState
                                          .marketChart?.type.index ??
                                      0],
                                  MarketChartTimeInterval.values[
                                      marketChartState.marketChart?.timeInterval
                                              .index ??
                                          4])
                              .map((e) =>
                                  FlSpot(e[0].toDouble(), e[1].toDouble()))
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
                                      text: '\n\$ ${e.y.toCurrency()}',
                                      // text: '\n${DateTime.fromMillisecondsSinceEpoch(e.x.toInt()).toLocal().hour}:${DateTime.fromMillisecondsSinceEpoch(e.x.toInt()).toLocal().minute}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            ScreenConfig.scaledFontSize(0.7),
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
            if (marketChartState.status == MarketChartStateStatus.loading)
              Center(
                child: CupertinoActivityIndicator(
                  radius: ScreenConfig.scaledHeight(0.02),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Error fetching market data',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenConfig.scaledFontSize(0.8),
          ),
        ),
        TextButton(
          onPressed: onRetry,
          child: Text(
            'Retry',
            style: TextStyle(
              color: Colors.amber[700],
              fontSize: ScreenConfig.scaledFontSize(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
