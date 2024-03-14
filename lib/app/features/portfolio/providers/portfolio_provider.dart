


import 'package:cryptosight/app/features/portfolio/data/repositories/portfolio_repository.dart';
import 'package:cryptosight/app/features/portfolio/domain/notifiers/portfolio_notifier.dart';
import 'package:cryptosight/services/portfolio_hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final portfolioHiveServiceProvider = Provider<PortfolioHiveService>((ref) {
  return PortfolioHiveService();
});

final portfolioRepositoryProvider = Provider<PortfolioRepository>((ref) {
  final hiveService = ref.read(portfolioHiveServiceProvider);
  return PortfolioRepository(hiveService: hiveService);
});

final portfolioNotifierProvider = StateNotifierProvider<PortfolioNotifier, PortfolioState>((ref) {
  final repository = ref.watch(portfolioRepositoryProvider);
  return PortfolioNotifier(ref, repository: repository);
});