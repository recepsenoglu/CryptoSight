import 'package:cryptosight/app/features/news/presentation/news_screen.dart';
import 'package:flutter/material.dart';

import 'route_names.dart';


class AppRouter {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.initial:
        return MaterialPageRoute(builder: (_) => const NewsScreen());

      default:
        return _errorRoute();
    }
  }

  static void navigateTo(String routeName, {Object? arguments}) async {
    await navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
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
