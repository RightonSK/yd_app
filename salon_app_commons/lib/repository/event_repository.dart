import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/event.dart';
import '../domain/event_participant.dart';

class EventRepository {
  static EventRepository? _instance;

  EventRepository._internal();

  factory EventRepository() {
    return _instance ??= EventRepository._internal();
  }

  Future<List<Event>> fetchAllEvents() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('event')
        .orderBy('dayOfWeek', descending: false)
        .get();
    return snapshot.docs.map((doc) {
      return Event.doc(doc);
    }).toList();
  }

  Future<List<Event>> fetchRecurringEvents() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('event')
        .where('isRecurring', isEqualTo: true)
        .orderBy('dayOfWeek', descending: false)
        .get();
    return snapshot.docs.map((doc) {
      return Event.doc(doc);
    }).toList();
  }

  Future<List<Event>> fetchSingleEvents() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('event')
        .where('isRecurring', isEqualTo: false)
        .orderBy('date', descending: false)
        .get();
    return snapshot.docs.map((doc) {
      return Event.doc(doc);
    }).toList();
  }

  Future addEvent(String eventId, Event event) async {
    return FirebaseFirestore.instance
        .collection('event')
        .doc(eventId)
        .set(event.toJson());
  }

  Future<Event> fetchEvent(String eventId) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('event').doc(eventId).get();
    return Event.doc(snapshot);
  }

  Stream<Event> fetchEventStream(String eventId) {
    final stream = FirebaseFirestore.instance
        .collection('event')
        .doc(eventId)
        .snapshots()
        .map((snapshot) => Event.doc(snapshot));
    return stream;
  }

  Future updateIsOpen(String eventId, bool isOpen) async {
    return FirebaseFirestore.instance.collection('event').doc(eventId).update({
      'isOpen': isOpen,
    });
  }

  /// CheckoutSessionを追加する
  Future addEventParticipant(String eventId, String userId) async {
    final data = {
      'id': userId,
      'createdAt': Timestamp.now(),
    };
    return await FirebaseFirestore.instance
        .collection('event')
        .doc(eventId)
        .collection('participants')
        .doc(userId)
        .set(data);
  }

  // 質問zoom取得
  Future<List<EventParticipant>> fetchParticipants(String event) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('event')
        .doc(event)
        .collection('participants')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return EventParticipant.doc(doc);
    }).toList();
  }
}
