import 'package:cryptosight/app/features/add_transaction/presentation/add_transaction_screen.dart';
import 'package:cryptosight/app/features/coin_detail/presentation/coin_detail_screen.dart';
import 'package:cryptosight/app/features/market_cap/data/models/coin_market_data_model.dart';
import 'package:cryptosight/app/features/market_cap/data/models/coin_simple_data_model.dart';
import 'package:cryptosight/app/navigation/main_navigation.dart';
import 'package:flutter/material.dart';

import 'route_names.dart';

class AppRouter {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.initial:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case RouteNames.mainNavigation:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case RouteNames.coinDetail:
        return MaterialPageRoute(
            builder: (_) =>
                CoinDetailScreen(settings.arguments as CoinMarketDataModel));
      case RouteNames.addTransaction:
        return MaterialPageRoute(
            builder: (_) => AddTransactionScreen(
                settings.arguments as CoinSimpleDataModel));

      default:
        return _errorRoute();
    }
  }

  static void navigateTo(String routeName, {Object? arguments}) async {
    await navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static Future<void> navigateToAndExpectResult(
      String routeName, Function(dynamic) onResult,
      {Object? arguments}) async {
    final result = await navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
    onResult(result);
  }

  static void goBack() {
    navigatorKey.currentState!.pop();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Page not found!'),
        ),
      );
    });
  }
}
