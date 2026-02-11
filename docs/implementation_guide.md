# 小売店販売店員向けアプリ 実装手順書

## 1. プロジェクトの初期設定

### 1.1. Flutterプロジェクトの作成
1.  `flutter create <project_name>` コマンドで新しいFlutterプロジェクトを作成します。
2.  作成されたプロジェクトディレクトリに移動します (`cd <project_name>`)。
3.  `flutter pub get` を実行し、初期依存関係を解決します。
    *   **検証**: `flutter run` コマンドを実行し、デフォルトのカウンターアプリがWeb、Android、iOSシミュレーター/デバイスで正常に起動することを確認します。

### 1.2. 主要な依存関係の追加
1.  `pubspec.yaml` ファイルを開き、以下の主要なパッケージを `dependencies:` セクションに追加します。
    *   状態管理 (例: `provider: ^6.0.0` または `flutter_bloc: ^8.1.0`, `riverpod: ^2.0.0`)
    *   HTTP通信 (例: `dio: ^5.0.0` または `http: ^0.13.0`)
    *   安全なストレージ (例: `flutter_secure_storage: ^7.0.0`)
    *   認証 (例: `flutter_appauth: ^6.0.0`)
    *   ルーティング (例: `go_router: ^6.0.0`)
    *   テスト (`dev_dependencies:` に `mockito: ^5.0.0`)
2.  `flutter pub get` を再度実行し、新しい依存関係を取得します。
    *   **検証**: ターミナルでエラーが表示されず、`pubspec.lock` ファイルが更新され、追加したパッケージがリストされていることを確認します。

### 1.3. ディレクトリ構造の初期構築
設計書の「2.6. ディレクトリ・ファイル構成」に基づき、`lib/` 配下に以下の主要なディレクトリを作成します。
*   `lib/core/` (`constants`, `error`, `network`, `util` サブディレクトリを含む)
*   `lib/data/` (`datasources`, `models`, `repositories` サブディレクトリを含む)
*   `lib/domain/` (`entities`, `usecases` サブディレクトリを含む)
*   `lib/presentation/` (`auth`, `home`, `message_registration`, `sales_performance`, `shared`, `common_widgets` サブディレクトリを含む)
*   `lib/routes/`
*   `lib/di/`
    *   **検証**: VS Codeのファイルエクスプローラーまたはターミナルの `ls -R lib/` コマンドで、上記ディレクトリが正しく作成されていることを確認します。

## 2. 認証基盤 (Keycloak) との連携

### 2.1. Keycloakクライアントの設定
1.  Keycloak管理コンソールにアクセスし、以下の設定を行います。
    *   レルムを作成または選択します。
    *   クライアントを作成し、クライアントID、クライアントシークレット（必要であれば）、および `Redirect URIs` をアプリのリダイレクトURI（例: `com.example.app://callback` for mobile, `http://localhost:port/callback` for web）に設定します。
    *   ユーザーを作成し、ロール（例: `sales`）を割り当てます。
2.  Keycloakサーバーのエンドポイント情報をアプリの定数ファイル（例: `lib/core/constants/app_constants.dart`）に記述します。
    *   `Keycloak_Authority`: `https://your-keycloak-instance.com/auth/realms/your-realm`
    *   `Keycloak_ClientId`: Keycloakで設定したクライアントID
    *   `Keycloak_RedirectUri`: Keycloakで設定したリダイレクトURI
    *   `Keycloak_DiscoveryUrl`: `https://your-keycloak-instance.com/auth/realms/your-realm/.well-known/openid-configuration`
    *   **検証**: Keycloak管理コンソールでの設定が完了していること、および定数ファイルに正しい情報が記述されていることを確認します。

### 2.2. 認証パッケージの導入と設定
1.  `flutter_appauth` パッケージを `pubspec.yaml` に追加し、`flutter pub get` を実行します。
2.  `lib/data/datasources/auth_remote_datasource.dart` ファイルを作成し、`AuthRemoteDataSource` クラスを実装します。このクラス内で `FlutterAppAuth` を使用してKeycloakとの認証フロー（`authorizeAndExchangeCode` メソッドなど）を実装します。
3.  iOS の場合は `ios/Runner/Info.plist`、Android の場合は `android/app/build.gradle` や `android/app/src/main/AndroidManifest.xml` に `flutter_appauth` の設定（リダイレクトURIスキームなど）を追加します。
    *   **検証**: 最小限のUI（例えばテストボタン）を `main.dart` に作成し、ログイン処理を呼び出します。Keycloakの認証画面への遷移、ログイン成功後のトークン（Access Token, Refresh Token, ID Token）の取得がデバッグログに表示されることを確認します。

### 2.3. トークン管理の実装
1.  `flutter_secure_storage` パッケージを `pubspec.yaml` に追加し、`flutter pub get` を実行します。
2.  `AuthRemoteDataSource` または別の `AuthRepository` クラス（例: `lib/data/repositories/auth_repository_impl.dart`）内で、取得したAccess TokenとRefresh Tokenを `flutter_secure_storage` を使って安全に保存・取得するメソッドを実装します。
3.  Refresh Tokenを使ったAccess Tokenの自動更新ロジックを実装します。このロジックは、APIリクエストのインターセプターなどで呼び出すことを検討します。
    *   **検証**: ログイン後にアプリを再起動し、保存されたトークンでユーザーセッションが継続できることを確認します。Keycloak側でAccess Tokenの有効期限を短く設定し、自動更新ロジックが正しく動作することを確認します。

## 3. API連携基盤の実装

### 3.1. APIクライアントの作成
1.  `dio` パッケージを `pubspec.yaml` に追加し、`flutter pub get` を実行します。
2.  `lib/core/network/api_client.dart` ファイルを作成し、`Dio` インスタンスを設定する `ApiClient` クラスを実装します。ベースURL、タイムアウト設定などを定義します。
    *   **検証**: テスト用のバックエンドAPIエンドポイント（もしあれば）に対して基本的なGETリクエストを送信するメソッドを実装し、応答が受け取れることを確認します。

### 3.2. インターセプターの導入
1.  `ApiClient` 内で `Dio` のインターセプター機能を使用します。
2.  `AuthInterceptor` を作成し、全ての認証が必要なAPIリクエストのヘッダーに保存されているAccess Tokenを自動的に付与するロジック（`Authorization: Bearer <Access Token>`）を実装します。
3.  APIからの `401 Unauthorized` 応答を検知した場合に、Refresh Tokenを使用してAccess Tokenの再取得を試行し、元のリクエストを再実行するロジックを実装します。
4.  APIからのエラーレスポンス（HTTPステータスコード、エラーメッセージ）を共通の `Failure` オブジェクト（`lib/core/error/failures.dart` で定義）に変換する `ErrorInterceptor` を実装します。
    *   **検証**: 認証トークンが必要なAPIを呼び出し、デバッグプロキシ（例: Charles Proxy, Fiddler）を使用してHTTPヘッダーにトークンが正しく付与されていることを確認します。Access Tokenの有効期限切れ後に自動更新が機能し、リクエストが再試行されることを確認します。

### 3.3. モデルの定義
設計書の「4.2. 各エンティティの属性と型」に基づき、`lib/data/models/` 配下に以下のデータモデルを実装します。
*   `user_model.dart`
*   `message_model.dart`
*   `sales_record_model.dart`
*   各モデルには `fromJson` (JSONからオブジェクトへの変換) および `toJson` (オブジェクトからJSONへの変換) メソッドを実装します。`json_serializable` パッケージの利用も検討します。
    *   **検証**: 各モデルがJSONとの間で正しく相互変換できることを単体テストで確認します。

## 4. 各画面の実装

### 4.1. ログイン画面 (`lib/presentation/auth/pages/login_page.dart`)
1.  ユーザー名入力フィールド、パスワード入力フィールド、ログインボタン、エラーメッセージ表示エリアなどのUIコンポーネントを実装します。
2.  フォームの入力値バリデーションロジックを実装します。
3.  ログインボタン押下時に、`AuthService` を呼び出して認証処理を開始します。
4.  認証の成功・失敗に応じて、画面遷移またはエラー表示を実装します。
    *   **検証**: 正しいKeycloakユーザー名とパスワードでログインし、ホーム画面へ遷移できることを確認します。不正なクレデンシャルでエラーメッセージが正しく表示されることを確認します。

### 4.2. ホーム画面 (`lib/presentation/home/pages/home_page.dart`)
1.  受信したメッセージをリスト表示するためのUIコンポーネント（`ListView.builder` など）を実装します。メッセージの本文（一部）や送信日時を表示します。
2.  リストの項目タップ時にメッセージ詳細を表示するエリアまたはダイアログを実装します。
3.  メッセージ登録画面および販売実績閲覧画面へのナビゲーションボタンを実装します。
    *   **検証**: ログイン成功後にホーム画面が正しく表示されること。モックデータまたは実際のAPIから取得したメッセージ一覧が表示されること。ナビゲーションボタンが正しく機能し、各画面へ遷移できることを確認します。

### 4.3. メッセージ登録画面 (`lib/presentation/message_registration/pages/message_registration_page.dart`)
1.  メッセージ本文を入力するためのテキストエリア、送信ボタン、入力バリデーションエラー表示用のUIコンポーネントを実装します。
2.  送信ボタン押下時に、APIを呼び出してメッセージを送信するロジックを実装します。
3.  送信成功時にはホーム画面へ戻るか、完了メッセージを表示します。送信失敗時にはエラーメッセージを表示します。
    *   **検証**: メッセージ本文を入力して送信し、正常にバックエンドに送信され、ホーム画面に戻ることを確認します。未入力などのバリデーションが機能することを確認します。

### 4.4. 販売実績閲覧画面 (`lib/presentation/sales_performance/pages/sales_performance_page.dart`)
1.  期間選択UI（日付ピッカーや期間プリセットボタンなど）、販売実績一覧を表示するためのUIコンポーネントを実装します。
2.  画面表示時、または期間選択UIで期間が変更された際に、バックエンドAPIから指定期間の販売実績データを取得し、画面に表示するロジックを実装します。
    *   **検証**: 期間を選択して販売実績データが正しく表示されることを確認します。モックデータまたは実際のAPIから取得したデータが表示されることを確認します。

## 5. 状態管理の導入

1.  選択した状態管理ソリューション（例: Provider, Riverpod, BLoC）をプロジェクトに導入し、設定を行います。
2.  各画面（ログイン、ホーム、メッセージ登録、販売実績）に対応するViewModelやBlocを作成します。
3.  ViewModel/Bloc内でデータ取得（ユースケース呼び出し）、UIの状態管理、ビジネスロジックへの連携を実装します。
4.  UIウィジェットからViewModel/Blocの状態を監視し、状態変更に応じてUIを再構築するように実装します。
    *   **検証**: 各画面でデータが正しくロードされ、ユーザー操作（入力、ボタンクリックなど）に応じてUIが意図通りに更新されることを確認します。

## 6. ルーティングの実装

1.  `go_router` パッケージを `pubspec.yaml` に追加し、`flutter pub get` を実行します。
2.  `lib/routes/app_router.dart` ファイルを作成し、アプリケーション全体のルーティングパスと遷移ロジック（`GoRoute` の定義など）を定義します。
3.  Keycloakの認証状態（ユーザーがログイン済みかどうか）に基づいて、ログイン画面とホーム画面へのアクセスを制御するリダイレクトロジック（`redirect` プロパティやルートガード）を実装します。
    *   **検証**:
        *   未ログイン状態でホーム画面に直接アクセスしようとすると、ログイン画面にリダイレクトされることを確認します。
        *   ログイン成功後、ホーム画面に正しく遷移できることを確認します。
        *   ログアウト後、再びログイン画面へ戻ることを確認します。

## 7. テストの実装

### 7.1. 単体テスト
1.  `lib/domain/usecases/` 配下のユースケース、`lib/data/repositories/` 配下のリポジトリ実装、`lib/data/models/` 配下のデータモデルに対して単体テスト（`flutter test`）を記述します。
2.  `mockito` パッケージを使用して、依存関係をモック化し、テスト対象のロジックが分離された状態で検証されるようにします。
    *   **検証**: `flutter test` コマンドを実行し、全ての単体テストがパスすることを確認します。可能であれば、`flutter test --coverage` でテストカバレッジを測定し、主要なロジックがカバーされていることを確認します。

### 7.2. ウィジェットテスト
1.  `lib/presentation/common_widgets/` 配下の共通ウィジェットや、`lib/presentation/<feature>/pages/` 配下の各画面UIコンポーネントに対してウィジェットテスト（`flutter test`）を記述します。
2.  UIが期待通りにレンダリングされるか、ユーザー操作（ボタンタップ、テキスト入力など）に正しく反応するかを検証します。
    *   **検証**: `flutter test` コマンドを実行し、全てのウィジェットテストがパスすることを確認します。

### 7.3. 統合テスト
1.  `integration_test/app_test.dart` ファイルを作成し、ログインからメッセージ送信、販売実績閲覧といった主要なユーザーフローに対して統合テスト（`flutter test integration_test`）を記述します。
2.  `integration_test` パッケージを使用して、実際にアプリを起動し、エンドツーエンドのシナリオを検証します。
    *   **検証**: `flutter test integration_test/app_test.dart` コマンドを実行し、アプリケーション全体のエンドツーエンドのフローが正常に動作することを確認します。

## 8. 非機能要件の考慮

### 8.1. UI/UXの最終調整
*   様々な画面サイズやデバイス（モバイル、タブレット、Webブラウザ）でUIが崩れないこと、適切なレイアウトであることを確認します。
*   必要に応じて、テキストサイズ、コントラスト、セマンティクスなど、アクセシビリティガイドラインに沿って調整を行います。
    *   **検証**: 各ターゲットプラットフォーム（Webブラウザ、Androidエミュレーター/デバイス、iOSシミュレーター/デバイス）でアプリを動作させ、デザインの一貫性と操作性を目視で確認します。

### 8.2. パフォーマンス最適化
*   `const` コンストラクタの使用漏れがないか確認し、可能な限り適用します。
*   リスト表示には `ListView.builder` を適切に使用し、アイテム数が多い場合のレンダリングパフォーマンスを最適化します。
*   不必要な `setState` 呼び出しや、`build` メソッド内での重い処理を削減します。
    *   **検証**: Flutter DevTools のパフォーマンスプロファイリングツールを使用し、UIの滑らかさやフレームレート、メモリ使用量にボトルネックがないか確認します。

### 8.3. セキュリティ対策の確認
*   `flutter_secure_storage` がトークンを安全に保管していることを再確認します。
*   バックエンドAPIおよびKeycloakとの通信が常にHTTPSプロトコルを利用していることを確認します。
*   ユーザーからの入力値に対するクライアントサイドおよびサーバーサイドのバリデーションが厳格に行われていることを確認し、SQLインジェクション、XSSなどの脆弱性から保護されていることを確認します。
    *   **検証**: セキュリティ監査ツールや専門家によるマニュアルレビューを実施し、脆弱性がないか確認します。

### 8.4. コーディング規約とドキュメンテーション
*   `dart format` コマンドを定期的に実行し、コードフォーマットをプロジェクト全体で統一します。
*   `flutter analyze` または `dart analyze` コマンドを定期的に実行し、警告やエラーがないことを確認します。
*   複雑なロジック、ビジネスルール、特定のAPI連携、または将来の変更が予想される箇所には、適切なコードコメントを記述します。
    *   **検証**: CI/CDパイプラインに自動チェック（`dart format --set-exit-if-changed`, `flutter analyze`）を組み込み、コード品質が維持されていることを確認します。コードレビューを通じて、コメントの適切性を確認します。