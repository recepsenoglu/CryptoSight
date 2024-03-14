import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

// ignore: constant_identifier_names
enum TransactionType { BUY, SELL }

@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final DateTime createdAt;
  @HiveField(2)
  final DateTime transactionDate;
  @HiveField(3)
  final TransactionType type;
  @HiveField(4)
  final String coinId;
  @HiveField(5)
  final double amount;
  @HiveField(6)
  final double price;

  TransactionModel({
    required this.name,
    required this.createdAt,
    required this.transactionDate,
    required this.type,
    required this.coinId,
    required this.amount,
    required this.price,
  });
}
