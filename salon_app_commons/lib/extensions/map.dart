import 'package:cloud_firestore/cloud_firestore.dart';

extension MapEx on Map {
  /// Map => DateTime
  DateTime? toDateTime() {
    if (this['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(this['_seconds'] * 1000);
    }
    return null;
  }

  /// Map => GeoPoint
  GeoPoint? toGeoPoint() {
    if (this['_latitude'] != null && this['_longitude'] != null) {
      return GeoPoint(this['_latitude'], this['_longitude']);
    }
    return null;
  }
}
