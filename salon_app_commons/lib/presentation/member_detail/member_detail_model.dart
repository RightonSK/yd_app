import 'package:flutter/material.dart';
import 'package:salon_app_commons/salon_app_commons.dart';

class MemberDetailModel extends ChangeNotifier {
  MemberDetailModel({this.nickname, this.userId});
  final String? nickname;
  final String? userId;

  User? user;
  List<UserApp> apps = [];
  List<Video> lectureVideos = [];
  List<Video> presentationVideos = [];
  List<Video> clipVideos = [];
  List<VideoHistory> videoHistories = [];
  List<MentorPlan>? mentorPlans;
  List<MentorPlan> notArchivedMentorPlans = [];
  bool isLoading = false;
  bool isShowDialog = false;
  String? myUid;
  int? purchaserFUTAmount;
  int? sellerFUTAmount;

  bool get isMe {
    return myUid == user?.id;
  }

  Future<void> init() async {
    startLoading();

    String? nickname = this.nickname;
    String? userId = this.userId;

    if (user == null) {
      final User user;

      if (nickname != null) {
        user = await UserRepository().fetchMemberByNickname(nickname);
      } else if (userId != null) {
        user = await UserRepository().fetchMember(userId);
      } else {
        final myUser = await UserRepository().fetchMyUser();
        assert(myUser != null);
        user = myUser!;
      }
      this.user = user;
    }
    apps = await UserRepository().fetchUserApps(user!.id);
    lectureVideos = await VideoRepository().fetchUserLectureVideos(user!.id);
    presentationVideos =
        await VideoRepository().fetchUserPresentationVideos(user!.id);
    clipVideos = await VideoRepository().fetchUserClipVideos(user!.id);
    videoHistories = await VideoRepository().fetchVideoHistory();
    myUid = UserRepository().myUid;
    mentorPlans = await MentorPlanRepository().fetchList(user!.id, myUid);
    purchaserFUTAmount =
        await UserRepository().getPurchaserFUTAmount(myUid: myUid!);
    sellerFUTAmount =
        await UserRepository().getSellerFUTAmount(userId: user!.id);
    endLoading();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<bool> checkPurchaseStatus(MentorPlan plan) async {
    return await UserRepository()
        .checkPurchaseStatus(userId: user!.id, id: plan.id);
  }

  Future<void> changeArchiveStatus(MentorPlan plan) async {
    await UserRepository().changeArchiveStatus(
        userId: user!.id, id: plan.id, isArchived: plan.isArchived);
  }

  Future<void> deleteMentorPlan(MentorPlan plan) async {
    await UserRepository().deleteMentorPlan(userId: user!.id, id: plan.id);
  }

  Future<void> requestFUTTransaction(MentorPlan plan) async {
    await UserRepository().requestFUTTransaction(
      myId: myUid!,
      sendUserId: user!.id,
      planId: plan.id,
      planName: plan.title,
      forWhat: FUTTransactionForWhat.mentorPlan.name,
      coinAmount: plan.futAmount,
    );
  }

  Future buyPlan(MentorPlan plan, String succeedUrl) async {
    final user = this.user;
    final myUser = await UserRepository().fetchMyUser();

    if (user == null || myUser == null) {
      throw 'ユーザー情報取得に失敗しました。リロードしてください';
    }
    final customerId = myUser.stripeId;
    final accountId = user.stripeAccountId;

    if (customerId == null || accountId == null) {
      throw 'ユーザー情報取得に失敗しました。リロードしてください';
    }
    final failedUrl = URLUtils.getCurrentUrl();
    final publishableKey = StripeConfig.publishableKey;
    final commissionRate =
        await TeacherCommissionRepository().fetchCommissionRate(user.id);
    final double commissionRateDouble = commissionRate.commissionRate;
    final url = await StripeRepository().fetchDestinationCheckoutURL(
      successUrl: succeedUrl,
      cancelUrl: failedUrl,
      publishableKey: publishableKey,
      customerId: customerId,
      targetUserId: user.id,
      accountId: accountId,
      planId: plan.id,
      title: plan.title,
      amount: plan.price,
      commissionRate: commissionRateDouble,
    );
    await URLUtils.launch(
      urlString: url,
      shouldOpenNewTab: false,
    );
  }

  Future updateUser() async {
    final user = this.user;

    if (user != null) {
      this.user = await UserRepository().fetchMember(user.id);
      notifyListeners();
    }
  }
}
