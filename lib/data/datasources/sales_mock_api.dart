import 'package:yd_app/domain/entities/sales_record.dart';

class SalesMockApi {
  Future<List<SalesRecord>> fetchSalesRecords() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      SalesRecord(
        id: '1',
        productId: 'AC-001',
        quantity: 3,
        sellerId: 'user001',
        soldAt: DateTime(2026, 2, 15, 10, 30),
      ),
      SalesRecord(
        id: '2',
        productId: 'TV-002',
        quantity: 1,
        sellerId: 'user001',
        soldAt: DateTime(2026, 2, 15, 13, 45),
      ),
      SalesRecord(
        id: '3',
        productId: 'WM-003',
        quantity: 2,
        sellerId: 'user002',
        soldAt: DateTime(2026, 2, 14, 16, 0),
      ),
      SalesRecord(
        id: '4',
        productId: 'RF-004',
        quantity: 1,
        sellerId: 'user003',
        soldAt: DateTime(2026, 2, 14, 11, 20),
      ),
      SalesRecord(
        id: '5',
        productId: 'AC-001',
        quantity: 2,
        sellerId: 'user002',
        soldAt: DateTime(2026, 2, 13, 15, 0),
      ),
    ];
  }
}
