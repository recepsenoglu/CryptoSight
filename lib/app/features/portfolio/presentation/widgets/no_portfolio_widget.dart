
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:cryptosight/shared/widgets/portfolio_name_popup.dart';
import 'package:flutter/material.dart';

class NoPortfolioWidget extends StatelessWidget {
  const NoPortfolioWidget({super.key, required this.onCreate});

  final Function(String) onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You have no portfolio yet.',
            style: TextStyle(
              fontSize: ScreenConfig.scaledFontSize(1.4),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text('Add a portfolio to get started.',
              style: TextStyle(
                fontSize: ScreenConfig.scaledFontSize(0.9),
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showPortfolioNamePopup(
                context: context,
                title: 'Create Portfolio',
                buttonText: 'Create',
                onAction: onCreate,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
            ),
            child: Text(
              'Add Portfolio',
              style: TextStyle(
                fontSize: ScreenConfig.scaledFontSize(0.9),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
