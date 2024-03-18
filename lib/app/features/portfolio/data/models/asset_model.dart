import 'package:cryptosight/app/features/market_cap/data/models/coin_simple_data_model.dart';

class AssetModel {
  final CoinSimpleDataModel coin;
  double totalAmount;
  double totalInvestment;

  AssetModel({
    required this.coin,
    required this.totalAmount,
    required this.totalInvestment,
  });

  AssetModel copyWith({
    CoinSimpleDataModel? coin,
    double? totalAmount,
    double? totalInvestment,
  }) {
    return AssetModel(
      coin: coin ?? this.coin,
      totalAmount: totalAmount ?? this.totalAmount,
      totalInvestment: totalInvestment ?? this.totalInvestment,
    );
  }

  double get currentTotalValue {
    return coin.currentPrice * totalAmount;
  }

  double get profit {
    return currentTotalValue - totalInvestment;
  }

  double get profitPercentage {
    return (profit / totalInvestment) * 100;
  }
}
