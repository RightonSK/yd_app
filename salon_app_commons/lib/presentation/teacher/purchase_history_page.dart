import 'package:flutter/material.dart';

import '../../salon_app_commons.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({
    super.key,
    required this.histories,
  });
  final List<PurchaseHistory> histories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("メンタープラン取引履歴"),
      ),
      backgroundColor: primaryNavyColor,
      body: ListView(
        shrinkWrap: true,
        children: histories
            .map((history) => PurchaseHistoryListTile(history: history))
            .toList(),
      ),
    );
  }
}

class PurchaseHistoryListTile extends StatelessWidget {
  const PurchaseHistoryListTile({
    Key? key,
    required this.history,
  }) : super(key: key);

  final PurchaseHistory history;

  @override
  Widget build(BuildContext context) {
    String priceText = history.price != null
        ? '${history.price?.getSplitAmount()}円'
        : '${history.fut?.getSplitAmount()}FUT';
    final commissionRate = history.commissionRate;

    if (commissionRate != null) {
      priceText += '\n(手数料${commissionRate * 100}%)';
    }
    return ListTile(
      title: Text(
        history.purchasedAt?.formatYMDWHM ?? '',
        style: const MultiLineStyle(color: Colors.white),
      ),
      subtitle: Text(
        '購入者: ${history.purchaserNickname ?? history.purchaser ?? '不明'}',
        style: const MultiLineStyle(color: Colors.white),
      ),
      trailing: Text(
        priceText,
        style: const BoldMultiLineStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
