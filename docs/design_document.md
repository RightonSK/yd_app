# アプリケーション設計書

## 1. はじめに

### 1.1. 本ドキュメントの目的

本ドキュメントは、「家電量販店販売店員向けアプリ」の技術的な設計を定義することを目的とする。要件定義書を基に、アーキテクチャ、フォルダ構成、画面ごとの詳細設計、状態管理の方針などを定める。

### 1.2. アプリケーションの概要

本アプリは、家電量販店の販売員を対象とし、日々の業務（メッセージのやり取り、販売実績の確認）を支援する。Flutter/Dartを用いてクロスプラットフォーム（Web, Android, iOS）に対応し、分かりやすく使いやすいUI/UXの提供を目指す。

## 2. アーキテクチャ設計

### 2.1. レイヤー設計

本アプリケーションでは、関心の分離を目的として、シンプルなレイヤードアーキテクチャを採用する。各レイヤーの責務は以下の通り。

-   **Presentation Layer (UI層)**
    -   **責務:** UIの表示、ユーザーからの入出力の受付。
    -   **構成要素:** `Page` (画面全体)、`Widget` (UI部品)、`ViewModel` (UIの状態とロジック)。
    -   **詳細:** ユーザー操作を`ViewModel`に通知し、`ViewModel`が公開する状態を監視してUIを更新する。FlutterのWidgetツリーがこの層の主役となる。

-   **Application Layer (アプリケーション層)**
    -   **責務:** ユースケースの実現。UIからの要求に応じて、ドメイン層やインフラ層を調整する。
    -   **構成要素:** `ViewModel` (実質的にこの層を担う)、`Provider` (Riverpod)。
    -   **詳細:** `ViewModel`はUIの状態を保持し、ドメインのエンティティやビジネスロジックに直接は依存しない。`Repository`を通じてデータ操作を行う。

-   **Domain Layer (ドメイン層)**
    -   **責務:** アプリケーションのコアなビジネスルールとデータ構造を定義する。
    -   **構成要素:** `Entity` (データ構造)。
    -   **詳細:** この層は特定のフレームワークやUIに依存しない、純粋なDartコードで記述される。

-   **Infrastructure Layer (インフラ層)**
    -   **責務:** 外部システム（データベース、API、デバイス機能など）との通信を担う。
    -   **構成要素:** `Repository` (実装)、`DataSource` (APIクライアント、DBクライアント)。
    -   **詳細:** データアクセスのロジックを`Repository`クラスとして直接実装する。今回はバックエンドが未定のため、ダミーデータを返すモックとして実装する。

### 2.2. フォルダ構成

上記のレイヤー設計に基づき、リポジトリのインターフェースを省略した、よりシンプルなフォルダ構成を採用する。

```
lib/
├── main.dart                 # アプリケーションのエントリポイント

├── core/                     # アプリ全体で共通の要素
│   ├── constants/            # 定数 (色、テーマ、APIエンドポイントなど)
│   └── widgets/              # 共通で利用するカスタムウィジェット

├── data/                     # Infrastructure Layer
│   ├── datasources/          # データソース (モックAPI)
│   │   ├── auth_mock_api.dart
│   │   ├── message_mock_api.dart
│   │   └── sales_mock_api.dart
│   └── repositories/         # Repositoryの実装クラス
│       ├── auth_repository.dart
│       ├── message_repository.dart
│       └── sales_repository.dart

├── domain/                   # Domain Layer
│   └── entities/             # ドメインエンティティ (データクラス)
│       ├── user.dart
│       ├── message.dart
│       └── sales_record.dart

└── presentation/             # Presentation Layer
    ├── login/                # ログイン画面
    │   ├── login_page.dart
    │   └── login_viewmodel.dart
    │
    ├── home/                 # ホーム画面
    │   ├── home_page.dart
    │   └── home_viewmodel.dart
    │
    ├── message/              # メッセージ登録画面
    │   ├── message_add_page.dart
    │   └── message_add_viewmodel.dart
    │
    └── sales/                # 販売実績閲覧画面
        ├── sales_records_page.dart
        └── sales_records_viewmodel.dart
```

## 3. 画面詳細設計

各画面は`Page`と`ViewModel`で構成される。

-   **ログイン画面 (`login/`)**
    -   `login_page.dart`: ユーザーIDとパスワードの入力フォーム、ログインボタンを持つStatelessWidget。ユーザー操作を`login_viewmodel.dart`に通知する。
    -   `login_viewmodel.dart`: ログイン状態（入力値、ローディング状態、エラーメッセージ）を管理する。認証ロジックを`AuthRepository`経由で実行する。

-   **ホーム画面 (`home/`)**
    -   `home_page.dart`: メッセージ一覧を表示する。`FutureProvider`などを用いて非同期にメッセージリストを取得・表示する。FAB（フローティングアクションボタン）からメッセージ登録画面へ遷移する。
    -   `home_viewmodel.dart`: メッセージ一覧の状態を管理する。`MessageRepository`からメッセージリストを取得する。

-   **メッセージ登録画面 (`message/`)**
    -   `message_add_page.dart`: メッセージ入力用のテキストフィールドと投稿ボタンを持つ。
    -   `message_add_viewmodel.dart`: 入力されたメッセージ内容や投稿処理の状態を管理し、`MessageRepository`経由でメッセージを投稿する。

-   **販売実績閲覧画面 (`sales/`)**
    -   `sales_records_page.dart`: 商品IDと販売個数のリストを表示する。`FutureProvider`を用いて非同期に実績データを取得・表示する。
    -   `sales_records_viewmodel.dart`: 販売実績リストの状態を管理する。`SalesRepository`から実績リストを取得する。

## 4. 状態管理設計 (Riverpod 2.0以降)

状態管理には`Riverpod`を採用し、以下の指針でProviderを使い分ける。

-   **`Provider`**:
    -   Repositoryの実装など、インスタンスをDI（依存性注入）するために使用する。状態は持たない。
    -   例: `final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());`

-   **`StateProvider`**:
    -   真偽値、数値、文字列など、単純で揮発性の高い状態を管理するために使用する。UIの一時的な状態（例：パスワードの表示/非表示）に利用。

-   **`NotifierProvider` / `AsyncNotifierProvider`**:
    -   画面の状態をカプセル化し、ビジネスロジックを持つ`ViewModel`をUIに提供するための、**Riverpod 2.0以降で推奨される**方法。
    -   `ViewModel`は`Notifier`または`AsyncNotifier`を継承して作成する。
    -   例: `final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(LoginViewModel.new);`

-   **`FutureProvider` / `StreamProvider`**:
    -   APIからのデータ取得など、非同期処理の結果をシンプルにUIに提供する場合に使用する。キャッシュやリフレッシュの機構を簡易に実装できる。
    -   例: `final messagesProvider = FutureProvider((ref) => ref.watch(messageRepositoryProvider).fetchMessages());`

## 5. データモデル設計

要件定義書で定義したデータモデルを、Domain層のEntityとして実装する。

-   **User (`user.dart`)**: ユーザー情報を保持する。
-   **Message (`message.dart`)**: メッセージ情報を保持する。
-   **SalesRecord (`sales_record.dart`)**: 販売実績情報を保持する。

これらのクラスは、イミュータブル（不変）な`data class`として定義する。`freezed`パッケージの利用を推奨する。
