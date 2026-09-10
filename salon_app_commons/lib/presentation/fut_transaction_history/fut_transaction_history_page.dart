import 'package:flutter/material.dart';

import '../../salon_app_commons.dart';

class FUTTransactionHistoryPage extends StatelessWidget {
  const FUTTransactionHistoryPage({super.key, required this.futTransactions});
  final List<FUTTransaction> futTransactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("FUT取引履歴"),
      ),
      backgroundColor: primaryNavyColor,
      body: ListView(
        shrinkWrap: true,
        children: futTransactions
            .map(
              (transaction) => ListTile(
                title: Text(
                  transaction.createdAt.toString(),
                  style: const MultiLineStyle(color: Colors.white),
                ),
                subtitle: Text(
                  transaction.reason,
                  style: const MultiLineStyle(color: Colors.white),
                ),
                trailing: Text(
                  transaction.coinAmount.toString(),
                  style: const BoldMultiLineStyle(color: Colors.white),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
