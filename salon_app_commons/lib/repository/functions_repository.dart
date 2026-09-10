import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:salon_app_commons/repository/user_repository.dart';

import '../utils/log_utils.dart';

/// CloudFunctions関連の操作をまとめたクラス (Singleton)
class FunctionsRepository {
  static FunctionsRepository? _instance;
  FunctionsRepository._internal();

  /// コンストラクタ
  factory FunctionsRepository() {
    return _instance ??= FunctionsRepository._internal();
  }

  Future<String> validateSlackEmail(String email) async {
    try {
      final result = await call(
        functionName: 'api-validateSlackEmail',
        parameters: {
          'slack_email': email,
        },
      );
      return result.data; // slackId
    } on FirebaseFunctionsException catch (e) {
      logger.d(e);
      switch (e.message) {
        case 'users_not_found': // slack APIのエラーをそのまま使ってる。
          throw ('まだFlutter大学のSlackに登録されていないユーザーです。招待メールから参加してください。');
        case 'already-exists':
          throw ('同じSlackメールアドレスがすでに登録されています');
        default:
          throw ('予期せぬエラーが発生しております。運営にご連絡ください。');
      }
    }
  }

  Future<String> searchSlackTimes(String timesName) async {
    try {
      final result = await call(
        functionName: 'api-searchSlackTimes',
        parameters: {
          'slack_times_name': timesName,
          'user_id': UserRepository().myUid,
        },
      );
      final String channelId = result.data;
      logger.d('channelId: $channelId');
      return channelId;
    } on FirebaseFunctionsException catch (e) {
      logger.d(e);
      switch (e.message) {
        case 'channel-not-found': // slack APIのエラーをそのまま使ってる。
          throw ('そのような名前のslackチャンネルが存在しません');
        case 'already-exists':
          throw ('同名のtimesがすでに登録されています');
        default:
          throw ('予期せぬエラーが発生しております。運営にご連絡ください。');
      }
    }
  }

  /// Githubユーザー名が有効かどうか検証する
  /// 検証NGの場合は例外をthrowする
  /// レスポンスとしてはgithub_usernameが帰ってくる
  Future<String> validateGithubId(int githubId) async {
    try {
      final functions = FirebaseFunctions.instanceFor(
        app: Firebase.app(),
        region: 'asia-northeast1',
      );
      final callable = functions.httpsCallable('api-validateGithubId');
      final result = await callable.call(
        {
          'github_id': githubId,
        },
      );
      final githubUsername = result.data;
      return githubUsername;
    } on FirebaseFunctionsException catch (e) {
      throwGitHubError(e);
      return '';
    } catch (e) {
      logger.d(e);
      throw ('エラーが発生しました');
    }
  }

  /// Githubユーザー名が有効かどうか検証する
  /// 検証NGの場合は例外をthrowする
  Future validateGithubUsername(String githubUsername) async {
    try {
      final functions = FirebaseFunctions.instanceFor(
        app: Firebase.app(),
        region: 'asia-northeast1',
      );
      final callable = functions.httpsCallable('api-validateGithubUsername');
      await callable.call(
        {
          'github_username': githubUsername,
        },
      );
    } on FirebaseFunctionsException catch (e) {
      throwGitHubError(e);
    } catch (e) {
      logger.d(e);
      throw ('エラーが発生しました');
    }
  }

  Future<List<String>> getNotificationTopicArray(String iidToken) async {
    try {
      final functions = FirebaseFunctions.instanceFor(
        app: Firebase.app(),
        region: 'asia-northeast1',
      );
      final callable = functions.httpsCallable('api-getNotificationTopics');
      final result = await callable.call(
        {
          'iidToken': iidToken,
        },
      );
      // check if the type is List<String>
      if (result.data is List) {
        return result.data.cast<String>();
      } else {
        return [];
      }
    } on FirebaseFunctionsException catch (e) {
      logger.d(e);
      rethrow;
    } catch (e) {
      logger.d(e);
      rethrow;
    }
  }

  /// CloudFunctionsを呼び出す
  Future<HttpsCallableResult> call({
    required String functionName,
    String? region,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final functions = FirebaseFunctions.instanceFor(
        app: Firebase.app(),
        region: region ?? 'asia-northeast1',
      );
      final callable = functions.httpsCallable(functionName);
      return await callable.call(parameters);
    } catch (e) {
      logger.d(e);
      rethrow;
    }
  }

  Future<void> throwGitHubError(FirebaseFunctionsException e) {
    logger.d(e);
    final error = GitHubError.fromCode(e.code);
    throw (error.message);
  }
}

enum GitHubError {
  alreadyExists,
  notFound,
  unavailable,
  invalidUsername;

  // Method to get the error message
  String get message {
    switch (this) {
      case GitHubError.alreadyExists:
        return '同名のGithubユーザー名が存在しています';
      case GitHubError.notFound:
        return 'Githubユーザーが見つかりませんでした。誤入力していないかご確認ください';
      case GitHubError.unavailable:
        return 'まだGithubのオーガニゼーションに登録されていないユーザーです。「[GitHub] You\'re invited to join the @flutteruniv organization」というタイトルの招待メールを確認し、メール内のボタンから参加してください';
      case GitHubError.invalidUsername:
        return 'Githubユーザー名が正しくありません';
    }
  }

  // Static method to map an error code to the GitHubError enum
  static GitHubError fromCode(String code) {
    switch (code) {
      case 'already-exists':
        return GitHubError.alreadyExists;
      case 'not-found':
        return GitHubError.notFound;
      case 'unavailable':
        return GitHubError.unavailable;
      default:
        return GitHubError.invalidUsername;
    }
  }
}
