# 家電量販店店員向け販売支援アプリ 設計書 v1.0

## 1. 概要
本ドキュメントは、家電量販店の販売店員向けの販売支援アプリケーションの設計を定義するものです。
主な機能として、店舗内の重要メッセージ共有機能や、個人の販売実績の記録・閲覧機能を提供し、店舗内の円滑なコミュニケーションと販売員のモチベーション向上、販売効率の向上を目指します。

## 2. ターゲットユーザー
- 家電量販店の販売店員

## 3. 技術仕様
- **開発言語・フレームワーク**: Flutter / Dart
- **対応プラットフォーム**: Web, Android, iOS
- **バックエンド**: モック（開発初期段階ではダミーデータを使用）
- **認証**: 簡易的なID/パスワード認証
- **状態管理**: Riverpod (flutter_riverpod v2.0系)
- **UI/UX**:
    - Material Designをベースとし、直感的で分かりやすいデザインを採用。
    - 誰でも簡単に操作できるシンプルなユーザーインターフェースを目指す。

## 4. アーキテクチャ設計

### 4.1. レイヤー設計
アプリケーションの保守性と拡張性を考慮し、以下のシンプルな3層レイヤー設計を採用します。簡易的なアプリのため、Data層のRepositoryはインターフェースを設けず、具象クラスとして直接実装します。

1.  **Presentation層**:
    - 役割: UIの表示とユーザーからの入力を担当。
    - 構成: FlutterのWidget、各画面に対応するPageとViewModel（StateNotifier）。
    - ViewModelがApplication層のProviderを介してビジネスロジックを呼び出し、UIの状態を管理する。

2.  **Application層 (ビジネスロジック)**:
    - 役割: アプリケーション固有のビジネスルールやユースケースを実装。
    - 構成: `Riverpod`の`Provider`としてビジネスロジックを定義。Presentation層とData層を仲介する。

3.  **Data層**:
    - 役割: データへのアクセスを担当。
    - 構成: `Repository`クラスを実装。RepositoryがAPIやデータベースとの通信を担う。
    - 現段階では、モックデータを返す`MockRepository`を実装する。

### 4.2. フォルダ構成
`lib`ディレクトリ配下のフォルダ構成は以下の通りです。（インターフェースを省略したシンプルな構成）

```
lib/
├── main.dart                 # アプリケーションのエントリポイント
│
├── presentation/             # Presentation層
│   ├── login/                # ログイン画面
│   │   ├── login_page.dart
│   │   └── login_viewmodel.dart
│   │
│   ├── home/                 # ホーム画面
│   │   ├── home_page.dart
│   │   └── home_viewmodel.dart
│   │
│   ├── message/              # メッセージ登録画面
│   │   ├── message_register_page.dart
│   │   └── message_register_viewmodel.dart
│   │
│   └── sales/                # 販売実績閲覧画面
│       ├── sales_performance_page.dart
│       └── sales_performance_viewmodel.dart
│
├── domain/                   # Domain層 (ビジネスロジックとモデル)
│   └── models/               # データモデル (User, Message, SalesRecordなど)
│       ├── user.dart
│       └── message.dart
│
└── data/                     # Data層
    ├── mock/                 # モックデータ
    │   └── dummy_data.dart
    │
    └── repositories/         # Repositoryの実装
        └── sales_repository.dart
```

## 5. 画面仕様

### 5.1. ログイン画面 (LoginPage)
- **目的**: ユーザーがアプリケーションを利用するための認証を行う。
- **主要コンポーネント**:
    - ユーザーID入力フィールド (`TextFormField`)
    - パスワード入力フィールド (`TextFormField`)
    - ログインボタン (`ElevatedButton`)
- **機能**:
    - ViewModelで入力値を検証。
    - ログインボタン押下時、認証処理（モック）を呼び出す。
    - 認証成功後、ホーム画面に遷移する。

### 5.2. ホーム画面 (HomePage)
- **目的**: アプリケーションのメイン画面。共有メッセージを閲覧できる。
- **主要コンポーネント**:
    - アプリケーションバー (`AppBar`) にログアウトボタンを配置。
    - メッセージ一覧を表示するリスト (`ListView`)。各メッセージはカード形式で表示。
    - メッセージ登録画面へ遷移するフローティングアクションボタン (`FloatingActionButton`)。
    - 販売実績閲覧画面へ遷移するためのナビゲーションメニュー (`BottomNavigationBar`等)。
- **機能**:
    - ViewModelがメッセージ一覧をリポジトリから取得し、画面に表示する。
    - 各画面へのナビゲーション機能を提供する。

### 5.3. メッセージ登録画面 (MessageRegisterPage)
- **目的**: 店員が他のスタッフに共有したいメッセージを登録する。
- **主要コンポーネント**:
    - メッセージタイトル入力フィールド (`TextFormField`)
    - メッセージ本文入力エリア (`TextFormField`、複数行)
    - 登録ボタン (`ElevatedButton`)
- **機能**:
    - ViewModelで入力値を管理。
    - 登録ボタン押下時、リポジトリを介してメッセージを保存（モック）。
    - 登録完了後、ホーム画面に戻り、 Snackbar等で完了通知を表示する。

### 5.4. 販売実績閲覧画面 (SalesPerformancePage)
- **目的**: ログインユーザー自身の販売実績（商品IDと販売個数）を閲覧する。
- **主要コンポーネント**:
    - 販売実績を一覧表示するリスト (`ListView`または`DataTable`)。
    - 実績は商品IDと販売個数のペアで表示する。
- **機能**:
    - ViewModelがログインユーザーの販売実績をリポジトリから取得し、画面に表示する。
    - 将来的には日付でのフィルタリング機能なども検討。

## 6. データモデル（モック）
開発初期段階で使用するデータモデルの定義。

- **User**: ユーザー情報
  ```dart
  class User {
    final String id;
    final String name;
  }
  ```
- **Message**: メッセージ情報
  ```dart
  class Message {
    final String id;
    final String title;
    final String content;
    final String authorId; // 作成者のUserID
    final DateTime createdAt;
  }
  ```
- **SalesRecord**: 販売実績
  ```dart
  class SalesRecord {
    final String id;
    final String productId; // 商品ID
    final int quantity;     // 販売個数
    final String sellerId;   // 販売員のUserID
    final DateTime soldAt;   // 販売日時
  }
  ```

## 7. コーディング規約
- **コメント**:
    - ソースコードには処理の意図がわかるようにコメントを豊富に記述する。
    - 特に、ViewModelやビジネスロジックの複雑な部分には、なぜその処理が必要なのかを明記する。
    - 各Widgetやクラス、メソッドには、その役割を説明するDocコメントを記述する。
- **状態管理**:
    - Riverpodの`Provider`は、関連する機能ごとにファイルを分割し、可読性を高める。
    - `ref.watch`と`ref.read`を適切に使い分け、不要なリビルドを防ぐ。
- **その他**:
    - `flutter analyze`の警告が出ないように、静的解析のルールを遵守する。
    - 定数は`const`で定義し、一元管理する。
