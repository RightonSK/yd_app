import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yd_app/data/datasources/sales_mock_api.dart';
import 'package:yd_app/domain/entities/sales_record.dart';

class SalesRepository {
  final SalesMockApi _api = SalesMockApi();

  Future<List<SalesRecord>> fetchSalesRecords() {
    return _api.fetchSalesRecords();
  }
}

final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  return SalesRepository();
});
