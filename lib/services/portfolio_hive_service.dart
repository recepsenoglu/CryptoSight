import 'package:cryptosight/app/features/portfolio/data/models/portfolio_model.dart';
import 'package:cryptosight/app/features/portfolio/data/models/transaction_model.dart';
import 'package:hive/hive.dart';

class PortfolioHiveService {
  final String boxName = 'portfolio';

  PortfolioHiveService() {
    _registerAdapter();
  }

  void _registerAdapter() {
    Hive.registerAdapter(PortfolioModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
  }

  Future<void> addPortfolio(PortfolioModel portfolio) async {
    final box = await Hive.openBox<PortfolioModel>(boxName);
    await box.add(portfolio);
  }

  Future<List<PortfolioModel>> getPortfolios() async {
    final box = await Hive.openBox<PortfolioModel>(boxName);
    return box.values.toList();
  }

  Future<void> updatePortfolio(int index, PortfolioModel portfolio) async {
    final box = await Hive.openBox<PortfolioModel>(boxName);
    await box.putAt(index, portfolio);
  }

  Future<void> deletePortfolio(int index) async {
    final box = await Hive.openBox<PortfolioModel>(boxName);
    await box.deleteAt(index);
  }

  Future<void> addTransaction(
      int portfolioIndex, TransactionModel transaction) async {
    final box = await Hive.openBox<PortfolioModel>(boxName);
    final portfolio = box.getAt(portfolioIndex);
    portfolio?.transactions.add(transaction);
    await box.putAt(portfolioIndex, portfolio!);
  }
}
