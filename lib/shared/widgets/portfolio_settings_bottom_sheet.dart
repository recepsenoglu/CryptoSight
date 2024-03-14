import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:cryptosight/shared/widgets/custom_confirmation_dialog.dart';
import 'package:cryptosight/shared/widgets/portfolio_name_popup.dart';
import 'package:flutter/material.dart';

void showPortfolioSettings(
  BuildContext context, {
  required String portfolioName,
  required Function(String) onEditName,
  required VoidCallback onClearCoins,
  required VoidCallback onDeletePortfolio,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.edit,
                size: ScreenConfig.scaledHeight(0.028),
              ),
              title: const Text('Edit Name'),
              titleTextStyle: TextStyle(
                fontSize: ScreenConfig.scaledFontSize(0.95),
                fontWeight: FontWeight.w600,
              ),
              onTap: () {
                Navigator.of(context).pop();
                showPortfolioNamePopup(
                  context: context,
                  title: 'Edit Portfolio Name',
                  initialName: portfolioName,
                  buttonText: 'Save',
                  onAction: (name) {
                    onEditName(name);
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_sweep,
                size: ScreenConfig.scaledHeight(0.028),
              ),
              title: const Text('Clear Coins'),
              titleTextStyle: TextStyle(
                fontSize: ScreenConfig.scaledFontSize(0.95),
                fontWeight: FontWeight.w600,
              ),
              onTap: () {
                Navigator.of(context).pop();
                showCustomConfirmationDialog(
                  context: context,
                  title: 'Clear Coins',
                  content: 'Are you sure you want to clear all coins from this '
                      'portfolio? This action cannot be undone.',
                  confirmButtonText: 'Clear',
                  onConfirm: () {
                    onClearCoins();
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_forever,
                size: ScreenConfig.scaledHeight(0.028),
              ),
              title: const Text('Delete Portfolio'),
              titleTextStyle: TextStyle(
                fontSize: ScreenConfig.scaledFontSize(0.95),
                fontWeight: FontWeight.w600,
              ),
              onTap: () {
                Navigator.of(context).pop();
                showCustomConfirmationDialog(
                  context: context,
                  title: 'Delete Portfolio',
                  content: 'Are you sure you want to delete this portfolio? '
                      'This action cannot be undone.',
                  confirmButtonText: 'Delete',
                  onConfirm: () {
                    onDeletePortfolio();
                  },
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
