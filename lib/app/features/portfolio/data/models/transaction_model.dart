// ignore_for_file: constant_identifier_names

import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 3)
enum TransactionType { 
  @HiveField(0)
  BUY,
  @HiveField(1)
  SELL,
  }

@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  DateTime createdAt;
  @HiveField(1)
  DateTime transactionDate;
  @HiveField(2)
  TransactionType type;
  @HiveField(3)
  final String coinId;
  @HiveField(4)
  double amount;
  @HiveField(5)
  double price;

  TransactionModel({
    required this.createdAt,
    required this.transactionDate,
    required this.coinId,
    this.type = TransactionType.BUY,
    this.amount = 0.0,
    this.price = 0.0,
  });

  TransactionModel copyWith({
    DateTime? createdAt,
    DateTime? transactionDate,
    TransactionType? type,
    String? coinId,
    double? amount,
    double? price,
  }) {
    return TransactionModel(
      createdAt: createdAt ?? this.createdAt,
      transactionDate: transactionDate ?? this.transactionDate,
      type: type ?? this.type,
      coinId: coinId ?? this.coinId,
      amount: amount ?? this.amount,
      price: price ?? this.price,
    );
  }
}
