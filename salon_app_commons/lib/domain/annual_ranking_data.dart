import 'package:cloud_firestore/cloud_firestore.dart';

class AnnualRankingData {
  final String mostJoinedJointDevelopmentPerson;
  final String mostJoinedStudyMeetingPerson;
  final String mostJoinedMorningGatherPerson;
  final String mostJoinedPersonalDevZoomPerson;
  final String mostJoinedPartyZoomPerson;
  final String mostCutVideoPerson;
  final String mostOneOnOnePerson;
  final String mostAssignedVideoPerson;

  final String mostJoinedJointDevelopmentPersonPhotoUrl;
  final String mostJoinedStudyMeetingPersonPhotoUrl;
  final String mostJoinedMorningGatherPersonPhotoUrl;
  final String mostJoinedPersonalDevZoomPersonPhotoUrl;
  final String mostJoinedPartyZoomPersonPhotoUrl;
  final String mostCutVideoPersonPhotoUrl;
  final String mostOneOnOnePersonPhotoUrl;
  final String mostAssignedVideoPersonPhotoUrl;

  final int mostJoinedJointDevelopmentCount;
  final int mostJoinedStudyMeetingCount;
  final int mostJoinedMorningGatherCount;
  final int mostJoinedPersonalDevZoomCount;
  final int mostJoinedPartyZoomCount;
  final int mostCutVideoCount;
  final int mostOneOnOneCount;
  final int mostAssignedVideoCount;

  AnnualRankingData({
    required this.mostJoinedJointDevelopmentPerson,
    required this.mostJoinedStudyMeetingPerson,
    required this.mostJoinedMorningGatherPerson,
    required this.mostJoinedPersonalDevZoomPerson,
    required this.mostJoinedPartyZoomPerson,
    required this.mostCutVideoPerson,
    required this.mostOneOnOnePerson,
    required this.mostAssignedVideoPerson,
    required this.mostJoinedJointDevelopmentPersonPhotoUrl,
    required this.mostJoinedStudyMeetingPersonPhotoUrl,
    required this.mostJoinedMorningGatherPersonPhotoUrl,
    required this.mostJoinedPersonalDevZoomPersonPhotoUrl,
    required this.mostJoinedPartyZoomPersonPhotoUrl,
    required this.mostCutVideoPersonPhotoUrl,
    required this.mostOneOnOnePersonPhotoUrl,
    required this.mostAssignedVideoPersonPhotoUrl,
    required this.mostJoinedJointDevelopmentCount,
    required this.mostJoinedStudyMeetingCount,
    required this.mostJoinedMorningGatherCount,
    required this.mostJoinedPersonalDevZoomCount,
    required this.mostJoinedPartyZoomCount,
    required this.mostCutVideoCount,
    required this.mostOneOnOneCount,
    required this.mostAssignedVideoCount,
  });

  factory AnnualRankingData.doc(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AnnualRankingData(
      mostJoinedJointDevelopmentPerson:
          data['mostJoinedJointDevelopmentPerson'] ?? '',
      mostJoinedStudyMeetingPerson: data['mostJoinedStudyMeetingPerson'] ?? '',
      mostJoinedMorningGatherPerson:
          data['mostJoinedMorningGatherPerson'] ?? '',
      mostJoinedPersonalDevZoomPerson:
          data['mostJoinedPersonalDevZoomPerson'] ?? '',
      mostJoinedPartyZoomPerson: data['mostJoinedPartyZoomPerson'] ?? '',
      mostCutVideoPerson: data['mostCutVideoPerson'] ?? '',
      mostOneOnOnePerson: data['mostOneOnOnePerson'] ?? '',
      mostAssignedVideoPerson: data['mostAssignedVideoPerson'] ?? '',
      mostJoinedJointDevelopmentPersonPhotoUrl:
          data['mostJoinedJointDevelopmentPersonPhotoUrl'] ?? '',
      mostJoinedStudyMeetingPersonPhotoUrl:
          data['mostJoinedStudyMeetingPersonPhotoUrl'] ?? '',
      mostJoinedMorningGatherPersonPhotoUrl:
          data['mostJoinedMorningGatherPersonPhotoUrl'] ?? '',
      mostJoinedPersonalDevZoomPersonPhotoUrl:
          data['mostJoinedPersonalDevZoomPersonPhotoUrl'] ?? '',
      mostJoinedPartyZoomPersonPhotoUrl:
          data['mostJoinedPartyZoomPersonPhotoUrl'] ?? '',
      mostCutVideoPersonPhotoUrl: data['mostCutVideoPersonPhotoUrl'] ?? '',
      mostOneOnOnePersonPhotoUrl: data['mostOneOnOnePersonPhotoUrl'] ?? '',
      mostAssignedVideoPersonPhotoUrl:
          data['mostAssignedVideoPersonPhotoUrl'] ?? '',
      mostJoinedJointDevelopmentCount:
          data['mostJoinedJointDevelopmentCount'] ?? 0,
      mostJoinedStudyMeetingCount: data['mostJoinedStudyMeetingCount'] ?? 0,
      mostJoinedMorningGatherCount: data['mostJoinedMorningGatherCount'] ?? 0,
      mostJoinedPersonalDevZoomCount:
          data['mostJoinedPersonalDevZoomCount'] ?? 0,
      mostJoinedPartyZoomCount: data['mostJoinedPartyZoomCount'] ?? 0,
      mostCutVideoCount: data['mostCutVideoCount'] ?? 0,
      mostOneOnOneCount: data['mostOneOnOneCount'] ?? 0,
      mostAssignedVideoCount: data['mostAssignedVideoCount'] ?? 0,
    );
  }
}
