import 'package:cloud_firestore/cloud_firestore.dart';

class Info {
  final double peopleCount;
  final bool isMaintenanceMode;
  final double trainingPlanAvailableCount;
  final String? calendarImageURL;

  Info._({
    required this.peopleCount,
    required this.isMaintenanceMode,
    required this.trainingPlanAvailableCount,
    required this.calendarImageURL,
  });

  factory Info.doc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return Info._(
      peopleCount: data['peopleCount'].toDouble(),
      isMaintenanceMode: data['isMaintenanceMode'] ?? false,
      trainingPlanAvailableCount: data['trainingPlanAvailableCount'].toDouble(),
      calendarImageURL: data['calendarImageURL'],
    );
  }
}
