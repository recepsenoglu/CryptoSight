import 'package:cryptosight/app/features/market_cap/data/models/coin_simple_data_model.dart';
import 'package:cryptosight/app/features/portfolio/data/models/asset_model.dart';
import 'package:cryptosight/app/features/portfolio/data/models/transaction_model.dart';
import 'package:hive/hive.dart';

part 'portfolio_model.g.dart';

@HiveType(typeId: 1)
class PortfolioModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final DateTime createdAt;
  @HiveField(2)
  final List<TransactionModel> transactions;

  final List<AssetModel> assets = [];

  PortfolioModel({
    required this.name,
    required this.createdAt,
    required this.transactions,
  });

  double get totalInvestment {
    return transactions.fold(0, (previousValue, element) {
      if (element.type == TransactionType.BUY) {
        return previousValue + element.amount * element.price;
      }
      return previousValue;
    });
  }

  double get totalProfit {
    return assets.fold(0, (previousValue, element) {
      return previousValue + element.profit;
    });
  }

  double get totalProfitPercentage {
    return (totalProfit / totalInvestment) * 100;
  }

  double getCoinAmount(String coinId) {
    try {
      return assets
          .firstWhere((element) => element.coin.id == coinId)
          .totalAmount;
    } catch (e) {
      return 0;
    }
  }

  void calculateAssets(List<CoinSimpleDataModel> market) {
    assets.clear();
    for (var transaction in transactions) {
      if (assets.any((element) => element.coin.id == transaction.coinId)) {
        var asset = assets
            .firstWhere((element) => element.coin.id == transaction.coinId);
        if (transaction.type == TransactionType.BUY) {
          asset.totalAmount += transaction.amount;
          asset.totalInvestment += transaction.amount * transaction.price;
        } else {
          asset.totalAmount -= transaction.amount;
          asset.totalInvestment -= transaction.amount * transaction.price;
        }
      } else {
        var coin = market.firstWhere(
          (element) => element.id == transaction.coinId,
          orElse: () => CoinSimpleDataModel(
            id: transaction.coinId,
            name: 'Unknown',
            symbol: 'UNK',
            image: '',
            currentPrice: 0,
          ),
        );
        if (transaction.type == TransactionType.BUY) {
          assets.add(AssetModel(
            index: assets.length,
            coin: coin,
            totalAmount: transaction.amount,
            totalInvestment: transaction.amount * transaction.price,
          ));
        } else {
          assets.add(AssetModel(
            index: assets.length,
            coin: coin,
            totalAmount: -transaction.amount,
            totalInvestment: -transaction.amount * transaction.price,
          ));
        }
      }
    }
  }

  PortfolioModel copyWith(
      {String? name,
      DateTime? createdAt,
      List<TransactionModel>? transactions}) {
    return PortfolioModel(
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      transactions: transactions ?? this.transactions,
    );
  }
}
