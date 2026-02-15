# 小売店販売店員向けアプリ 設計書

## 1. はじめに

### 1.1. 文書目的

本設計書は、小売店販売店員向けアプリケーション（以下、「本アプリ」）の開発における技術的な設計方針を明確にすることを目的とします。要件定義書で定められた機能要件および非機能要件に基づき、システムの全体構成、各機能の詳細、データ構造、および実装方針を定義します。

### 1.2. 対象範囲

本設計書は、Flutter/Dart を用いて開発される本アプリのWeb、Android、iOS クライアントサイドの設計を対象とします。バックエンドAPIおよびKeycloak認証基盤自体の詳細な設計は対象外ですが、それらとの連携については言及します。

### 1.3. 参照ドキュメント

*   小売店販売店員向けアプリ 要件定義書 (requirements_definition.md)

## 2. 全体設計

### 2.1. システム構成図

本アプリは、Keycloakを認証基盤とし、REST APIを介してバックエンドと連携する構成をとります。
Flutterアプリケーションは単一のコードベースからWeb、Android、iOSの各プラットフォーム向けにビルドされます。

```
+----------------+       +-------------------+       +-----------------+       +--------------+
|                |       |                   |       |                 |       |              |
| Flutter App    | <---> | Backend API       | <---> | Keycloak        | <---> | Data Store   |
| (Web/Android/iOS)|       | (RESTful)         |       | (Auth Server)   |       | (Database)   |
|                |       |                   |       |                 |       |              |
+----------------+       +-------------------+       +-----------------+       +--------------+
       ^
       | HTTP/HTTPS
       v
+----------------+
| 販売店員       |
+----------------+
```

### 2.2. 使用技術スタック

*   **フロントエンドフレームワーク**: Flutter (v3.x 以降)
*   **プログラミング言語**: Dart (v2.x 以降)
*   **状態管理**: Riverpod を採用予定
*   **HTTP通信**: `http` パッケージまたは `Dio` パッケージ
*   **認証基盤**: Keycloak (OpenID Connect / OAuth 2.0)
*   **ルーティング**: `go_router` または `Navigator 2.0`
*   **テストフレームワーク**: `flutter_test`, `mockito`
*   **UIライブラリ**: Material Design または Cupertino UI を基盤とし、カスタムウィジェットでブランド統一

### 2.3. 開発環境・実行環境

*   **開発環境**:
    *   OS: macOS, Windows, Linux
    *   IDE: Visual Studio Code または Android Studio / IntelliJ IDEA
    *   Flutter SDK, Dart SDK
    *   Git
*   **実行環境**:
    *   Web: Chrome, Safari, Firefoxなどモダンブラウザ
    *   Android: Android OS xx.x 以上を搭載したスマートフォン、タブレット
    *   iOS: iOS xx.x 以上を搭載したiPhone、iPad

### 2.4. 認証・認可設計

Keycloakを認証基盤として利用し、OpenID Connect (OIDC) と OAuth 2.0 の標準プロトコルに従って認証・認可を実装します。

*   **認証フロー**:
    1.  ユーザーがログイン画面でID/パスワードを入力。
    2.  FlutterアプリはKeycloakの認証エンドポイントへリクエストを送信（Authorization Code Flow with PKCE）。
    3.  Keycloakが認証処理を行い、成功すればAuthorization Codeをアプリに返却。
    4.  アプリはAuthorization CodeとPKCEのCode Verifierを用いてKeycloakのTokenエンドポイントからAccess Token、Refresh Token、ID Tokenを取得。
    5.  Access Tokenを安全に保存し、バックエンドAPIへのリクエストに付与して認証済みユーザーとしてアクセス。
*   **トークン管理**:
    *   Access Tokenは有効期限が短いため、安全なストレージ（例: `flutter_secure_storage`）に保存し、有効期限が切れる前にRefresh Tokenを使用してAccess Tokenを再取得します。
    *   Refresh Tokenも安全に保存し、適切なタイミングでのみ使用します。
    *   ログアウト時は全てのトークンを破棄し、Keycloakのセッションも終了させます。
*   **認可**:
    *   Keycloakのユーザーロールやスコープを利用し、バックエンドAPI側で認可制御を行います。
    *   アプリ側では、ユーザーのロールに基づいてUI要素の表示/非表示や機能へのアクセス制御を行う場合があります。

### 2.5. API連携設計

バックエンドAPIとの通信にはRESTfulな設計を採用します。

*   **通信プロトコル**: HTTPS
*   **データ形式**: JSON
*   **エラーハンドリング**:
    *   APIからのエラーレスポンス（HTTPステータスコード、エラーメッセージ）を適切にハンドリングし、ユーザーに分かりやすく表示します。
    *   ネットワークエラーやタイムアウトも考慮した実装を行います。
*   **認証トークンの付与**: 全ての認証が必要なAPIリクエストには、Keycloakから取得したAccess TokenをHTTPヘッダー（`Authorization: Bearer <Access Token>`）に含めて送信します。

### 2.6. ディレクトリ・ファイル構成 (主要部分)

Flutterプロジェクトの標準的な構造をベースに、機能ごとのグループ化とシンプルなレイヤーを意識したディレクトリ分割を行います。

```
lib/
├── main.dart                      # アプリのエントリーポイント
├── app.dart                       # アプリケーション全体の設定やルーティング定義
├── core/                          # アプリケーション共通のコア機能（定数、ユーティリティなど）
│   ├── app_constants.dart         # アプリ全体で使用する定数
│   ├── app_errors.dart            # アプリ全体のエラー定義
│   └── app_utils.dart             # アプリ全体の共通ユーティリティ関数
├── services/                      # APIクライアント、認証サービス、データリポジトリなど、バックエンドとの連携やデータ永続化を担当
│   ├── api_client.dart            # Dioなどを利用したAPIクライアント
│   ├── auth_service.dart          # Keycloak連携を含む認証ロジック
│   ├── message_repository.dart    # メッセージ関連データのリポジトリ
│   └── sales_repository.dart      # 販売実績関連データのリポジトリ
├── models/                        # APIレスポンスやビジネスロジックで扱うデータモデル
│   ├── user_model.dart
│   ├── message_model.dart
│   └── sales_record_model.dart
├── common_widgets/                # アプリケーション全体で利用する共通ウィジェット
│   └── loading_indicator.dart
│   └── custom_button.dart
├── routes/                        # アプリケーションのルーティング定義
│   └── app_router.dart
├── presentation/                      
│   ├── auth/                      # 認証関連機能
│   │   ├── login_page.dart        # ログイン画面
│   │   └── login_viewmodel.dart   # ログイン画面のViewModel
│   ├── home/                      # ホーム画面関連機能
│   │   ├── home_page.dart         # ホーム画面
│   │   └── home_viewmodel.dart    # ホーム画面のViewModel
│   ├── message_registration/      # メッセージ登録関連機能
│   │   ├── message_registration_page.dart # メッセージ登録画面
│   │   └── message_registration_viewmodel.dart # メッセージ登録画面のViewModel
│   └── sales_performance/         # 販売実績閲覧関連機能
│       ├── sales_performance_page.dart # 販売実績閲覧画面
│       └── sales_performance_viewmodel.dart # 販売実績閲覧画面のViewModel
└── providers.dart                 # Provider/Riverpodのプロバイダ定義、依存性注入関連
```

## 3. 機能設計 (画面別)

### 3.1. ログイン画面 (`features/auth/login_page.dart`)

*   **画面概要**: ユーザー（販売店員）がKeycloakを介して認証を行うための画面です。
*   **UI要素**:
    *   ユーザー名入力フィールド
    *   パスワード入力フィールド
    *   ログインボタン
    *   エラーメッセージ表示エリア
    *   （オプション）パスワードリセットリンク
*   **遷移**:
    *   ログイン成功: ホーム画面へ遷移。
    *   ログイン失敗: エラーメッセージを表示。
    *   （オプション）パスワードリセットリンク押下: Keycloakのパスワードリセットフローへ遷移。
*   **データフロー**:
    1.  ユーザー入力 -> `login_viewmodel.dart` の状態として保持
    2.  ログインボタン押下 -> `login_viewmodel.dart` のログイン処理呼び出し -> `auth_service.dart` を介してKeycloak認証API呼び出し
    3.  Keycloakからトークン取得 -> `auth_service.dart` が `flutter_secure_storage` に保存
    4.  認証結果に応じて画面遷移またはエラー表示

### 3.2. ホーム画面 (メッセージ閲覧機能付き)

*   **画面概要**: ログイン後に最初に表示される画面で、受信メッセージの一覧表示と詳細閲覧、他画面へのナビゲーションを提供します。
*   **UI要素**:
    *   メッセージ一覧（リスト表示）：メッセージ本文（一部）、送信日時など。
    *   メッセージ詳細表示エリア（リスト項目タップ時）
    *   メッセージ登録画面へのナビゲーションボタン
    *   販売実績閲覧画面へのナビゲーションボタン
*   **遷移**:
    *   メッセージ登録ボタン押下: メッセージ登録画面へ遷移。
    *   販売実績閲覧ボタン押下: 販売実績閲覧画面へ遷移。
*   **データフロー**:
    1.  画面表示時 -> メッセージ取得ユースケース実行 -> バックエンドAPIからメッセージ一覧を取得
    2.  メッセージ一覧を画面に表示
    3.  メッセージ項目タップ時 -> そのメッセージの詳細を画面に表示

### 3.3. メッセージ登録画面

*   **画面概要**: 販売店員がメッセージを作成し、送信するための画面です。
*   **UI要素**:
    *   メッセージ本文入力用テキストエリア
    *   送信ボタン
    *   入力バリデーションエラー表示
*   **遷移**:
    *   送信成功: ホーム画面へ戻る、または完了メッセージ表示。
    *   送信失敗: エラーメッセージを表示。
*   **データフロー**:
    1.  ユーザー入力（メッセージ本文） -> 状態管理
    2.  送信ボタン押下 -> メッセージ登録ユースケース実行 -> バックエンドAPIへメッセージ送信
    3.  送信結果に応じて画面遷移またはエラー表示

### 3.4. 販売実績閲覧画面 (商品IDと販売個数)

*   **画面概要**: 特定期間における商品の販売実績（商品IDと販売個数）を確認するための画面です。
*   **UI要素**:
    *   期間選択UI (日付ピッカー、期間プリセットボタンなど)
    *   販売実績一覧（リスト/テーブル表示）：商品ID、販売個数など
    *   （オプション）グラフ表示エリア
*   **遷移**:
    *   特になし（ホーム画面からの遷移が主）
*   **データフロー**:
    1.  画面表示時または期間選択時 -> 販売実績取得ユースケース実行 -> バックエンドAPIから指定期間の販売実績を取得
    2.  取得した販売実績データを画面に表示

## 4. データモデル設計

### 4.1. 主要エンティティ

*   **User**:
    *   `id` (Keycloakから取得するユーザーID)
    *   `username` (Keycloakのユーザー名)
    *   `email` (Keycloakのメールアドレス)
    *   `roles` (Keycloakのロール情報、認可制御に使用)
*   **Message**:
    *   `id` (メッセージID)
    *   `senderId` (送信者ユーザーID)
    *   `senderName` (送信者名)
    *   `body` (メッセージ本文)
    *   `sentAt` (送信日時)
*   **SalesRecord**:
    *   `id` (販売実績ID)
    *   `productId` (商品ID)
    *   `productName` (商品名)
    *   `quantity` (販売個数)
    *   `salesDate` (販売日)

### 4.2. 各エンティティの属性と型

| エンティティ    | 属性       | 型       | 説明                                    |
| :-------------- | :--------- | :------- | :-------------------------------------- |
| `User`          | `id`       | `String` | KeycloakのUUID                          |
|                 | `username` | `String` | Keycloakのユーザー名                    |
|                 | `email`    | `String` | Keycloakの登録メールアドレス            |
|                 | `roles`    | `List<String>` | Keycloakのロール（例: "admin", "sales"）|
| `Message`       | `id`       | `String` | メッセージを一意に識別するID            |
|                 | `senderId` | `String` | 送信者のユーザーID                      |
|                 | `senderName` | `String` | 送信者の表示名                          |
|                 | `body`     | `String` | メッセージの本文                        |
|                 | `sentAt`   | `DateTime` | メッセージが送信された日時              |
| `SalesRecord`   | `id`       | `String` | 販売実績を一意に識別するID              |
|                 | `productId`| `String` | 販売された商品のID                      |
|                 | `productName`| `String` | 販売された商品の名前（オプション）      |
|                 | `quantity` | `int`    | 販売個数                                |
|                 | `salesDate`| `DateTime` | 販売が行われた日時                      |

## 5. 非機能設計

### 5.1. UI/UX設計原則

*   **一貫性**: Material Design ガイドライン（Android/Web）および Cupertino Design ガイドライン（iOS）を基本とし、各プラットフォームの慣習に沿ったUI/UXを提供します。
*   **レスポンシブデザイン**: 様々な画面サイズやデバイス（スマートフォン、タブレット、Webブラウザ）に対応できるよう、柔軟なレイアウト設計を行います。
*   **アクセシビリティ**: 色覚多様性や視覚障がいを持つユーザーにも配慮したデザイン（コントラスト比、テキストサイズ、セマンティクスなど）を検討します。
*   **フィードバック**: ユーザーのアクション（ボタンタップ、データ送信など）に対して、視覚的・触覚的なフィードバックを適切に提供し、操作の確実性を高めます。

### 5.2. パフォーマンス設計

*   **ウィジェットの最適化**: `const` コンストラクタの使用、`RepaintBoundary` の活用により、不要なウィジェットの再構築を抑制します。
*   **非同期処理**: API通信やローカルストレージへのアクセスなど、時間のかかる処理は非同期で行い、UIスレッドをブロックしないようにします。`FutureBuilder` や `StreamBuilder` を適切に利用します。
*   **データ取得の最適化**: 必要なデータのみを取得し、ページネーションや遅延ロードを検討します。
*   **状態管理の最適化**: 不必要なウィジェットの再構築を防ぐため、状態管理ソリューション（Provider, Riverpod, BLoCなど）を適切に設計・実装します。

### 5.3. セキュリティ設計

*   **Keycloak連携**: 認証・認可はKeycloakに一元化し、OIDC/OAuth 2.0の標準に則った安全な実装を行います。
*   **トークンの安全な保管**: Access TokenおよびRefresh Tokenは、クライアントサイドの安全なストレージ（例: AndroidのKeyStore、iOSのKeychainを利用する `flutter_secure_storage`）に保管します。Webアプリの場合は、HttpOnly属性を持つSecure Cookieなどを検討します。
*   **HTTPS通信**: バックエンドAPIおよびKeycloakとの通信は全てHTTPSを使用し、通信の盗聴や改ざんを防ぎます。
*   **入力検証**: クライアントサイドでの入力バリデーションに加え、バックエンドAPI側でも厳格な入力検証を行い、SQLインジェクション、XSSなどの脆弱性を防止します。
*   **依存関係の管理**: 定期的に`pubspec.yaml`の依存関係をチェックし、既知の脆弱性を持つライブラリを使用していないか確認します。

### 5.4. 保守性・拡張性設計

*   **クリーンアーキテクチャ/レイヤードアーキテクチャ**: presentation, domain, data の各層に分割し、責務の分離と依存関係の方向性を明確にします。
*   **コーディング規約**: Dart/Flutter の公式ガイドラインおよびプロジェクト固有の規約を定め、コードの一貫性を保ちます。`dart format` および `dart analyze` をCI/CDに組み込みます。
*   **コメント**: 複雑なロジックやビジネスルール、APIの仕様など、コードだけでは理解しにくい箇所には適切なコメントを記述します。
*   **テスト**:
    *   **単体テスト (Unit Test)**: ドメイン層のユースケースやデータ層のリポジトリなど、ビジネスロジックの各単位でテストを記述します。
    *   **ウィジェットテスト (Widget Test)**: UIコンポーネントが正しくレンダリングされ、ユーザー操作に適切に反応するかをテストします。
    *   **統合テスト (Integration Test)**: アプリケーション全体のフロー（画面遷移、API連携など）が期待通りに動作するかをテストします。
*   **依存性注入 (DI)**: 依存性注入のパターン（GetIt, Provider, Riverpodなど）を適用し、コンポーネント間の結合度を下げ、テスト容易性と保守性を向上させます。

## 6. 想定される成果物ファイル

本プロジェクトで生成される主要なファイルとディレクトリの例を以下に示します。

### 6.1. プロジェクトルート

*   `pubspec.yaml`: プロジェクトのメタデータ、依存関係、アセット定義
*   `pubspec.lock`: 依存関係の具体的なバージョンをロックするファイル
*   `README.md`: プロジェクトの概要、セットアップ方法、実行方法など
*   `.gitignore`: Gitで管理しないファイルを指定
*   `analysis_options.yaml`: Dart静的解析ツールの設定ファイル
*   `web/`: Webアプリビルド成果物
*   `android/`: Androidアプリプロジェクト
*   `ios/`: iOSアプリプロジェクト

### 6.2. `lib/` ディレクトリ (主要部分)

*   `main.dart`
*   `app.dart`
*   `core/`
    *   `constants/app_constants.dart`
    *   `error/failures.dart`
    *   `network/api_client.dart`
    *   `util/date_formatter.dart`
*   `data/`
    *   `datasources/auth_remote_datasource.dart` (Keycloak連携)
    *   `datasources/message_remote_datasource.dart`
    *   `datasources/sales_remote_datasource.dart`
    *   `models/user_model.dart`
    *   `models/message_model.dart`
    *   `models/sales_record_model.dart`
    *   `repositories/auth_repository_impl.dart`
    *   `repositories/message_repository_impl.dart`
    *   `repositories/sales_repository_impl.dart`
*   `domain/`
    *   `entities/user.dart`
    *   `entities/message.dart`
    *   `entities/sales_record.dart`
    *   `repositories/auth_repository.dart`
    *   `repositories/message_repository.dart`
    *   `repositories/sales_repository.dart`
    *   `usecases/auth/login_usecase.dart`
    *   `usecases/message/get_messages_usecase.dart`
    *   `usecases/message/send_message_usecase.dart`
    *   `usecases/sales/get_sales_performance_usecase.dart`
*   `presentation/`
    *   `auth/login_page.dart`
    *   `auth/viewmodels/login_viewmodel.dart` (またはProvider, BLoCなど)
    *   `home/home_page.dart`
    *   `home/message_detail_page.dart`
    *   `home/viewmodels/home_viewmodel.dart`
    *   `message_registration/message_registration_page.dart`
    *   `message_registration/viewmodels/message_registration_viewmodel.dart`
    *   `sales_performance/sales_performance_page.dart`
    *   `sales_performance/viewmodels/sales_performance_viewmodel.dart`
    *   `shared/app_colors.dart`
    *   `shared/app_styles.dart`
    *   `common_widgets/custom_button.dart`
    *   `common_widgets/loading_indicator.dart`
*   `routes/app_router.dart`
*   `di/injection_container.dart` (依存性注入設定)

### 6.3. `test/` ディレクトリ

*   `unit_test/`
    *   `domain/usecases/auth/login_usecase_test.dart`
    *   `data/repositories/auth_repository_impl_test.dart`
    *   `data/models/message_model_test.dart`
*   `widget_test/`
    *   `presentation/auth/pages/login_page_test.dart`
    *   `presentation/common_widgets/custom_button_test.dart`
*   `integration_test/`
    *   `app_test.dart`

### 6.4. `docs/` ディレクトリ

*   `requirements_definition.md` (要件定義書)
*   `design_document.md` (本設計書)
*   `gemini_cli/`
    *   `gemini_cli_vscode_guide.md`
    *   `gemini_vscode_modify.md`

上記の内容で設計書を作成します。