import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yd_app/data/repositories/sales_repository.dart';
import 'package:yd_app/domain/entities/sales_record.dart';

final salesRecordsProvider = FutureProvider<List<SalesRecord>>((ref) {
  return ref.watch(salesRepositoryProvider).fetchSalesRecords();
});
