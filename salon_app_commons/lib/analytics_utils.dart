class AnalyticsUtils {
  static Future sendLog(AnalyticsEvent event) async {
    // const serviceName = 'web';
    // final name = '${serviceName}_${event.name}';
    // return FirebaseAnalytics.instance.logEvent(name: name);
  }
}

enum AnalyticsEvent {
  btnSignUp,
  btnRegister,
  btnVerifyEmail,
  btnSelectPlan,
  screenCompletePayment,
  btnGoToTutorial,
  btnRegisterNickname,
  btnRegisterSlack,
  btnRegisterGitHub,
  btnShareTwitter,
  btnDownloadAppIOS,
  btnDownloadAppAndroid,
  btnQuestionnaire,
  btnGoToMyPage,
}
