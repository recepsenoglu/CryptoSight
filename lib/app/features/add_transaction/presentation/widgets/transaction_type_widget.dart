import 'package:cryptosight/app/features/portfolio/data/models/transaction_model.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class TransactionTypeWidget extends StatelessWidget {
  const TransactionTypeWidget({
    super.key,
    required this.transactionType,
    required this.onTransactionTypeChanged,
  });

  final TransactionType transactionType;
  final Function() onTransactionTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        title: const Text('Transaction Type'),
        titleTextStyle: TextStyle(
          fontSize: ScreenConfig.scaledFontSize(0.9),
          fontWeight: FontWeight.w600,
        ),
        subtitle: Text(transactionType.name.toUpperCase()),
        subtitleTextStyle: TextStyle(
          fontSize: ScreenConfig.scaledFontSize(0.8),
        ),
        trailing: Icon(
          Icons.change_circle,
          size: ScreenConfig.scaledWidth(0.05),
        ),
        contentPadding: ScreenConfig.horizontalDynamicPadding(0.04),
        onTap: () {
          onTransactionTypeChanged();
        },
      ),
    );
  }
}
