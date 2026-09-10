import 'package:cloud_firestore/cloud_firestore.dart';

class AnnualUserFUTData {
  final int jointDevelopmentCount;
  final int studyMeetingCount;
  final int morningGatherCount;
  final int personalDevZoomCount;
  final int partyZoomCount;
  final int cutVideoCount;
  final int oneOnOneCount;
  final int assignedVideoCount;

  AnnualUserFUTData({
    required this.jointDevelopmentCount,
    required this.studyMeetingCount,
    required this.morningGatherCount,
    required this.personalDevZoomCount,
    required this.partyZoomCount,
    required this.cutVideoCount,
    required this.oneOnOneCount,
    required this.assignedVideoCount,
  });

  factory AnnualUserFUTData.doc(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AnnualUserFUTData(
      jointDevelopmentCount: data['jointDevelopmentCount'] ?? 0,
      studyMeetingCount: data['studyMeetingCount'] ?? 0,
      morningGatherCount: data['morningGatherCount'] ?? 0,
      personalDevZoomCount: data['personalDevZoomCount'] ?? 0,
      partyZoomCount: data['partyZoomCount'] ?? 0,
      cutVideoCount: data['cutVideoCount'] ?? 0,
      oneOnOneCount: data['oneOnOneCount'] ?? 0,
      assignedVideoCount: data['assignedVideoCount'] ?? 0,
    );
  }
}
