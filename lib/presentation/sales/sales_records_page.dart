import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yd_app/presentation/sales/sales_records_viewmodel.dart';

class SalesRecordsPage extends ConsumerWidget {
  const SalesRecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(salesRecordsProvider);

    return salesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('エラー: $error')),
      data: (records) {
        if (records.isEmpty) {
          return const Center(child: Text('販売実績がありません'));
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(salesRecordsProvider.future),
          child: ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.shopping_cart)),
                  title: Text('商品ID: ${record.productId}'),
                  subtitle: Text(
                    '販売数: ${record.quantity}個 / 販売者: ${record.sellerId}',
                  ),
                  trailing: Text(
                    '${record.soldAt.month}/${record.soldAt.day}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
