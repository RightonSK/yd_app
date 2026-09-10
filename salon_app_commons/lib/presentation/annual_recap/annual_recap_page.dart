import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../salon_app_commons.dart';
import 'annual_recap_model.dart';

const noImage = CircleAvatar(
  backgroundColor: Colors.blueGrey,
  radius: 40 / 2,
  child: Icon(
    Icons.person,
    size: 40 / 2,
    color: Colors.white,
  ),
);

class AnnualRecapPage extends StatelessWidget {
  static const String route = '/annual_recap';

  final PreferredSizeWidget appBar;
  const AnnualRecapPage({Key? key, required this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AnnualRecapModel>(
      create: (_) => AnnualRecapModel()..init(),
      child: Scaffold(
        backgroundColor: primaryNavyColor,
        appBar: appBar,
        body: Consumer<AnnualRecapModel>(builder: (context, model, child) {
          final annualRankingData = model.annualRankingData;
          final personalAnnualData = model.personalAnnualData;

          if (annualRankingData == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Image.asset('salon_app_commons/resources/recap2024.gif'),
                      const SizedBox(
                        height: 48,
                      ),
                      // annualRankingDataを表示
                      Column(
                        children: [
                          const Text(
                            '共同開発に最も参加した人',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: annualRankingData
                                      .mostJoinedJointDevelopmentPersonPhotoUrl
                                      .isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(40 / 2),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: annualRankingData
                                            .mostJoinedJointDevelopmentPersonPhotoUrl,
                                        fit: BoxFit.fitHeight,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return noImage;
                                        },
                                      ),
                                    )
                                  : noImage,
                            ),
                          ),
                          Text(
                            '${annualRankingData.mostJoinedJointDevelopmentPerson}: ${annualRankingData.mostJoinedJointDevelopmentCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            'あなた: ${personalAnnualData?.jointDevelopmentCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Column(
                        children: [
                          const Text(
                            '共同勉強会に最も参加した人',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: annualRankingData
                                      .mostJoinedStudyMeetingPersonPhotoUrl
                                      .isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(40 / 2),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: annualRankingData
                                            .mostJoinedStudyMeetingPersonPhotoUrl,
                                        fit: BoxFit.fitHeight,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return noImage;
                                        },
                                      ),
                                    )
                                  : noImage,
                            ),
                          ),
                          Text(
                            '${annualRankingData.mostJoinedStudyMeetingPerson}: ${annualRankingData.mostJoinedStudyMeetingCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            'あなた: ${personalAnnualData?.studyMeetingCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      // mostJoinedMorningGatherPerson
                      Column(
                        children: [
                          const Text(
                            '朝活に最も参加した人',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: annualRankingData
                                      .mostJoinedMorningGatherPersonPhotoUrl
                                      .isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(40 / 2),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: annualRankingData
                                            .mostJoinedMorningGatherPersonPhotoUrl,
                                        fit: BoxFit.fitHeight,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return noImage;
                                        },
                                      ),
                                    )
                                  : noImage,
                            ),
                          ),
                          Text(
                            '${annualRankingData.mostJoinedMorningGatherPerson}: ${annualRankingData.mostJoinedMorningGatherCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            'あなた: ${personalAnnualData?.morningGatherCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      // mostJoinedPersonalDevZoomPerson
                      Column(
                        children: [
                          const Text(
                            '個人開発Zoomに最も参加した人',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: annualRankingData
                                      .mostJoinedPersonalDevZoomPersonPhotoUrl
                                      .isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(40 / 2),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: annualRankingData
                                            .mostJoinedPersonalDevZoomPersonPhotoUrl,
                                        fit: BoxFit.fitHeight,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return noImage;
                                        },
                                      ),
                                    )
                                  : noImage,
                            ),
                          ),
                          Text(
                            '${annualRankingData.mostJoinedPersonalDevZoomPerson}: ${annualRankingData.mostJoinedPersonalDevZoomCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            'あなた: ${personalAnnualData?.personalDevZoomCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      // mostJoinedPartyZoomPerson
                      Column(
                        children: [
                          const Text(
                            'オンライン交流会に最も参加した人',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: annualRankingData
                                      .mostJoinedPartyZoomPersonPhotoUrl
                                      .isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(40 / 2),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: annualRankingData
                                            .mostJoinedPartyZoomPersonPhotoUrl,
                                        fit: BoxFit.fitHeight,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return noImage;
                                        },
                                      ),
                                    )
                                  : noImage,
                            ),
                          ),
                          Text(
                            '${annualRankingData.mostJoinedPartyZoomPerson}: ${annualRankingData.mostJoinedPartyZoomCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            'あなた: ${personalAnnualData?.partyZoomCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      // mostCutVideoPerson
                      Column(
                        children: [
                          const Text(
                            '最も動画を切り抜いた人',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: annualRankingData
                                      .mostCutVideoPersonPhotoUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(40 / 2),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: annualRankingData
                                            .mostCutVideoPersonPhotoUrl,
                                        fit: BoxFit.fitHeight,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return noImage;
                                        },
                                      ),
                                    )
                                  : noImage,
                            ),
                          ),
                          Text(
                            '${annualRankingData.mostCutVideoPerson}: ${annualRankingData.mostCutVideoCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            'あなた: ${personalAnnualData?.cutVideoCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      // mostOneOnOnePerson
                      Column(
                        children: [
                          const Text(
                            '最も1on1をした人',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: annualRankingData
                                      .mostOneOnOnePersonPhotoUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(40 / 2),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: annualRankingData
                                            .mostOneOnOnePersonPhotoUrl,
                                        fit: BoxFit.fitHeight,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return noImage;
                                        },
                                      ),
                                    )
                                  : noImage,
                            ),
                          ),
                          Text(
                            '${annualRankingData.mostOneOnOnePerson}: ${annualRankingData.mostOneOnOneCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            'あなた: ${personalAnnualData?.oneOnOneCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      // mostAssignedVideoPerson
                      Column(
                        children: [
                          const Text(
                            '最も動画にユーザーを付与した人',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: annualRankingData
                                      .mostAssignedVideoPersonPhotoUrl
                                      .isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(40 / 2),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: annualRankingData
                                            .mostAssignedVideoPersonPhotoUrl,
                                        fit: BoxFit.fitHeight,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return noImage;
                                        },
                                      ),
                                    )
                                  : noImage,
                            ),
                          ),
                          Text(
                            '${annualRankingData.mostAssignedVideoPerson}: ${annualRankingData.mostAssignedVideoCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Text(
                            'あなた: ${personalAnnualData?.assignedVideoCount}回',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Column(
                        children: [
                          const Text(
                            '【投票】\nエンジニアとして最も成長した人',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Image.asset(
                              'salon_app_commons/resources/2024_cobo.jpg'),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Column(
                        children: [
                          const Text(
                            '【投票】\nコミュニティを最も盛り上げてくれた人',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Image.asset(
                              'salon_app_commons/resources/2024_masaki.jpg'),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Column(
                        children: [
                          const Text(
                            '【投票】\n総合MVP',
                            style: BoldMultiLineStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Image.asset(
                              'salon_app_commons/resources/2024_kosuke.jpg'),
                        ],
                      ),

                      const SizedBox(
                        height: 48,
                      ),
                      const Text(
                        '今年も\nありがとうございました🎉',
                        style: BoldMultiLineStyle(
                          color: Colors.white,
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      RoundedActionButton(
                          isMobile: isMobile,
                          title: 'timesにシェアする',
                          onTap: () async {
                            // TODO: slackのtimesに投稿
                            await showTextDialog(context,
                                'クリップボードにURLをコピーし、slackのtimesに遷移します。timesに貼り付けてください🙏');
                            await model.shareToSlackTimes();
                          }),
                      const SizedBox(
                        height: 64,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
