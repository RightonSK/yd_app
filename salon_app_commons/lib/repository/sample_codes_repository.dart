import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_app_commons/domain/sample_code.dart';

class SampleCodesRepository {
  static SampleCodesRepository? _instance;
  SampleCodesRepository._internal();
  factory SampleCodesRepository() {
    return _instance ??= SampleCodesRepository._internal();
  }

  Future<List<SampleCode>> fetchAll() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('sample_codes').get();
    return snapshot.docs.map((doc) {
      return SampleCode.doc(doc);
    }).toList();
  }

  Future<SampleCode> fetch(String id) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sample_codes')
        .doc(id)
        .get();
    return SampleCode.doc(snapshot);
  }

  Future add(String eventId, SampleCode sampleCode) async {
    return FirebaseFirestore.instance
        .collection('sample_codes')
        .doc(eventId)
        .set(sampleCode.toJson());
  }
}
