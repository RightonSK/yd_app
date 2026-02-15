## 実装完了サマリー

| レイヤー | ファイル |
|---------|---------|
| **Domain** | `user.dart`, `message.dart`, `sales_record.dart` (freezed エンティティ) |
| **Data** | `auth_mock_api.dart`, `message_mock_api.dart`, `sales_mock_api.dart` (モックAPI) |
| **Data** | `auth_repository.dart`, `message_repository.dart`, `sales_repository.dart` (Riverpod Provider付き) |
| **Core** | `app_constants.dart` (テーマ・アプリ名) |
| **Presentation** | `login_page.dart` + `login_viewmodel.dart` (ログイン画面) |
| **Presentation** | `home_page.dart` + `home_viewmodel.dart` (メッセージ一覧 + BottomNav) |
| **Presentation** | `message_add_page.dart` + `message_add_viewmodel.dart` (メッセージ登録) |
| **Presentation** | `sales_records_page.dart` + `sales_records_viewmodel.dart` (販売実績) |
| **Entry** | `main.dart` (ProviderScope + ルーティング) |

## 検証結果
- `flutter analyze` — **No issues found**
- `flutter build web` — **ビルド成功**

## モックユーザー
| ユーザーID | パスワード |
|-----------|-----------|
| `user001` | `password001` |
| `user002` | `password002` |
| `user003` | `password003` |
