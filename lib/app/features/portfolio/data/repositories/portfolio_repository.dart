import 'package:cryptosight/app/features/portfolio/data/models/portfolio_model.dart';
import 'package:cryptosight/services/portfolio_hive_service.dart';

class PortfolioRepository {
  final PortfolioHiveService hiveService;

  PortfolioRepository({required this.hiveService});

  Future<void> addPortfolio(PortfolioModel portfolio) async {
    await hiveService.addPortfolio(portfolio);
  }

  Future<List<PortfolioModel>> getPortfolios() async {
    return await hiveService.getPortfolios();
  }

  Future<void> updatePortfolio(int index, PortfolioModel portfolio) async {
    await hiveService.updatePortfolio(index, portfolio);
  }

  Future<void> deletePortfolio(int index) async {
    await hiveService.deletePortfolio(index);
  }
}
