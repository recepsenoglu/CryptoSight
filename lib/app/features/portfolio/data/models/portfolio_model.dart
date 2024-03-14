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
