import 'package:flutter/material.dart';
import 'package:salon_app_commons/domain/user.dart';
import 'package:salon_app_commons/repository/user_repository.dart';

class MembersSearchModel extends ChangeNotifier {
  MembersSearchModel() {
    _init();
  }

  late final userSearchController = TextEditingController()
    ..addListener(notifyListeners);

  /// 自身を含んだ全メンバー
  List<User>? allMembers;

  /// 自分以外のメンバー
  List<User>? otherMembers;

  Future _init() async {
    await _fetchMembers();
    notifyListeners();
  }

  Future<void> _fetchMembers() async {
    final fetchedMembers = await UserRepository().fetchMembers();
    allMembers = [...fetchedMembers];
    // 端末のログインユーザーを削除する
    otherMembers = [...fetchedMembers]
      ..removeWhere((member) => member.id == UserRepository().myUid);
  }

  /// ニックネームでユーザーを検索する
  List<User> searchMemberByName({
    required List<User> members,
    required String searchWord,
  }) {
    // 検索ワードが空の場合、そのまま返す
    if (searchWord.isEmpty) {
      return members;
    }
    final searchedMembers = members
        .where(
          (element) => element.nickname?.contains(searchWord) ?? false,
        )
        .toList();
    return searchedMembers;
  }
}
