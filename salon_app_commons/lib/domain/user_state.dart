/// ユーザーの状態
enum UserState {
  // 初期化中
  waiting,

  // 未ログイン
  noLogin,

  //メールアドレス未認証
  noVerified,

  // サブスクがない
  noSubscription,

  // 無流プラン(2022年7月31日まで存在)
  freePlan,

  // nickname未登録
  noNickname,

  // slackEmail未登録
  noSlackEmail,

  // githubId未登録 (2023年4月にgithub_usernameから変更)
  noGithubId,

  // アンケート未回答
  notAnswerQuestionnaire,

  // サロンメンバー
  member,
}
