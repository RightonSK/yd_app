import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/reservation.dart';

class ReservationRepository {
  static ReservationRepository? _instance;
  ReservationRepository._internal();

  /// コンストラクタ
  factory ReservationRepository() {
    return _instance ??= ReservationRepository._internal();
  }

  /// 予約を作成する
  Future createReservation(Reservation reservation) async {
    final data = reservation.toJson();
    await FirebaseFirestore.instance.collection('reservations').doc(reservation.id).set(data);
  }

  /// 予約を取得する
  Future<List<Reservation>> fetchReservations() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('reservations').get();
    return snapshot.docs.map((doc) => Reservation.doc(doc)).toList();
  }

  /// 予約をキャンセル
  Future cancelReservation(String id) async {
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(id)
        .delete();
  }
}
