import 'package:cryptosight/app/features/add_transaction/domain/notifiers/add_transaction_notifier.dart';
import 'package:cryptosight/app/features/add_transaction/presentation/widgets/transaction_type_widget.dart';
import 'package:cryptosight/app/features/add_transaction/providers/add_transaction_provider.dart';
import 'package:cryptosight/app/features/market_cap/data/models/coin_simple_data_model.dart';
import 'package:cryptosight/shared/utils/extensions.dart';
import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:cryptosight/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransactionScreen extends ConsumerWidget {
  const AddTransactionScreen(this.coin, {super.key});

  final CoinSimpleDataModel coin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addTransactionState = ref.watch(addTransactionProvider(coin));

    if (addTransactionState.status == AddTransactionStateStatus.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(true);
      });
    }

    if (addTransactionState.status == AddTransactionStateStatus.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              addTransactionState.errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      });
    }

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          ref.read(addTransactionProvider(coin).notifier).resetState();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Add Transaction',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ScreenConfig.scaledFontSize(1.2),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: ScreenConfig.horizontalDynamicPadding(0.03).copyWith(
              bottom: ScreenConfig.scaledHeight(0.015),
            ),
            child: CustomScrollView(
              primary: true,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: ListTile(
                          title: Text(coin.name),
                          titleTextStyle: TextStyle(
                            fontSize: ScreenConfig.scaledFontSize(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: Text(coin.symbol.toUpperCase()),
                          subtitleTextStyle: TextStyle(
                            fontSize: ScreenConfig.scaledFontSize(0.8),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(coin.image),
                            radius: ScreenConfig.scaledWidth(0.04),
                          ),
                          contentPadding:
                              ScreenConfig.horizontalDynamicPadding(0.04),
                        ),
                      ),
                      TransactionTypeWidget(
                        transactionType: addTransactionState.transaction!.type,
                        onTransactionTypeChanged: () {
                          ref
                              .read(addTransactionProvider(coin).notifier)
                              .changeTransactionType();
                        },
                      ),
                      Card(
                        child: Padding(
                          padding:
                              ScreenConfig.symmetricDynamicPadding(0.03, 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Number of Coins',
                                style: TextStyle(
                                  fontSize: ScreenConfig.scaledFontSize(0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: ScreenConfig.scaledHeight(0.005),
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.number,
                                controller: null,
                                onChanged: (p0) => ref
                                    .read(addTransactionProvider(coin).notifier)
                                    .changeAmount(p0),
                              ),
                              SizedBox(
                                height: ScreenConfig.scaledHeight(0.02),
                              ),
                              Text(
                                'Price for 1 unit',
                                style: TextStyle(
                                  fontSize: ScreenConfig.scaledFontSize(0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: ScreenConfig.scaledHeight(0.005),
                              ),
                              CustomTextField(
                                prefixIcon: Icons.attach_money,
                                keyboardType: TextInputType.number,
                                controller: TextEditingController.fromValue(
                                  TextEditingValue(
                                    text: addTransactionState.transaction!.price
                                        .toCurrency(),
                                    selection: TextSelection.collapsed(
                                      offset: addTransactionState
                                          .transaction!.price
                                          .toCurrency()
                                          .length,
                                    ),
                                  ),
                                ),
                                onChanged: (p0) => ref
                                    .read(addTransactionProvider(coin).notifier)
                                    .changePrice(p0),
                              ),
                              SizedBox(
                                height: ScreenConfig.scaledHeight(0.02),
                              ),
                              Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: ScreenConfig.scaledFontSize(0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: ScreenConfig.scaledHeight(0.005),
                              ),
                              CustomTextField(
                                prefixIcon: Icons.calendar_today,
                                keyboardType: TextInputType.datetime,
                                controller: ref
                                    .read(addTransactionProvider(coin).notifier)
                                    .dateController,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2010),
                                    lastDate: DateTime.now(),
                                  ).then((value) {
                                    if (value != null) {
                                      value = value.copyWith(
                                        hour: DateTime.now().hour,
                                        minute: DateTime.now().minute,
                                      );
                                      ref
                                          .read(addTransactionProvider(coin)
                                              .notifier)
                                          .changeDate(value);
                                    }
                                  });
                                },
                              ),
                              SizedBox(
                                height: ScreenConfig.scaledHeight(0.025),
                              ),
                              Text(
                                "Total Price:",
                                style: TextStyle(
                                  fontSize: ScreenConfig.scaledFontSize(0.8),
                                ),
                              ),
                              Text(
                                "${(addTransactionState.transaction!.amount * addTransactionState.transaction!.price).toCurrency()} USD",
                                style: TextStyle(
                                  fontSize: ScreenConfig.scaledFontSize(1.1),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(addTransactionProvider(coin).notifier)
                              .saveTransaction();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: ScreenConfig.horizontalDynamicPadding(0.04),
                          backgroundColor: Colors.amber,
                        ),
                        child: addTransactionState.status ==
                                AddTransactionStateStatus.saving
                            ? SizedBox(
                                height: ScreenConfig.scaledFontSize(1.3),
                                width: ScreenConfig.scaledFontSize(1.3),
                                child: const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.black),
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: ScreenConfig.scaledFontSize(1),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
