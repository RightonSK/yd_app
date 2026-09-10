import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salon_app_commons/domain/annual_ranking_data.dart';
import 'package:salon_app_commons/domain/annual_user_fut_data.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class AnnualRecapModel extends ChangeNotifier {
  final repo = InfoRepository();

  bool isLoading = false;

  AnnualRankingData? annualRankingData;
  AnnualUserFUTData? personalAnnualData;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future init() async {
    await fetchAnnualRankingData();
    await fetchPersonalAnnualData();
    notifyListeners();
  }

  Future fetchAnnualRankingData() async {
    annualRankingData = await repo.fetchAnnualData2024();
  }

  Future fetchPersonalAnnualData() async {
    final user = await UserRepository().fetchMyUser();
    final uid = user?.id;

    if (uid == null) {
      return;
    }
    personalAnnualData = await repo.fetchPersonalData2024(uid);
  }

  Future shareToSlackTimes() async {
    String shareText = '${URLUtils.getBaseUrl()}/annual_recap';
    await Clipboard.setData(ClipboardData(text: shareText));
    final user = await UserRepository().fetchMyUser();
    final slackTimesUrl =
        'slack://channel?team=T012UQWDRQC&id=${user?.slackTimesId}';
    await URLUtils.launch(
      urlString: slackTimesUrl,
      shouldOpenNewTab: false,
    );
  }
}
