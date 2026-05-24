# Flutter エラー変換の実装方針 — extension vs factory 議論まとめ

## 背景

`flutterアドバイスメモ(Zenn記事統合版).docx` の **項目7「APIエラー変換」** で提示された `mapApiError` 関数について、「extension で実装するのがベストではないか？」という議論。

### 元のコード（項目7より）

```dart
AppException mapApiError(Object error) {
  if (error is DioException) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401) return const UnauthorizedException();
    if (statusCode == 403) return const ForbiddenException();
    if (statusCode == 500) return const ServerException();
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }
  }
  return const UnknownException();
}
```

---

## 議論の結論

**「extension だけ」では業務アプリのエラー変換窓口としてはベストとは言いにくい。**
ただし、**factory constructor と組み合わせる** ことで、extension の利点を活かしつつ「窓口の一本化」も実現できる。

---

## なぜ単純な extension はベストではないか

項目4で示されている通り、`mapApiError` は **複数のエラー源** を一元的に AppException へ変換する窓口の役割を持つ。

> Dio、Keycloak、OAS自動生成コード、APIサーバー由来のエラーを AppException に変換する。

| パターン | 問題点 |
|---|---|
| `extension on DioException` | DioException 以外（Keycloak例外、生の Object など）を呼び出し側で型判定する必要があり、責務が分散する |
| `extension on Object` | Object 全体を汚染するアンチパターン。すべての値に `.toAppException()` が生えてしまう |

extension は **静的解決** されるため、ポリモーフィズムが効かない。`Object error` を受け取って動的に分岐する用途には向かない。

---

## 推奨実装：factory constructor + 型ごとの extension

### 1. AppException 側（統一エントリポイント）

```dart
sealed class AppException implements Exception {
  const AppException({required this.code, required this.message});

  final String code;
  final String message;

  /// 任意のエラーを AppException に変換する統一エントリポイント
  factory AppException.from(Object error) => switch (error) {
    DioException e => e.toAppException(),
    // 将来追加: KeycloakException e => e.toAppException(),
    // 将来追加: ApiException e       => e.toAppException(),
    _ => const UnknownException(),
  };
}

class NetworkException extends AppException {
  const NetworkException()
      : super(
          code: 'E_NETWORK',
          message: '通信できません。ネットワークを確認してください。',
        );
}

class UnauthorizedException extends AppException {
  const UnauthorizedException()
      : super(
          code: 'E_UNAUTHORIZED',
          message: 'ログインの有効期限が切れました。再ログインしてください。',
        );
}

class ForbiddenException extends AppException {
  const ForbiddenException()
      : super(
          code: 'E_FORBIDDEN',
          message: 'この操作を行う権限がありません。',
        );
}

class ServerException extends AppException {
  const ServerException()
      : super(
          code: 'E_SERVER',
          message: 'サーバーで問題が発生しました。',
        );
}

class UnknownException extends AppException {
  const UnknownException()
      : super(
          code: 'E_UNKNOWN',
          message: '予期しないエラーが発生しました。',
        );
}
```

### 2. 型ごとの extension（変換ロジックを型の近くに配置）

```dart
extension DioExceptionMapper on DioException {
  AppException toAppException() {
    final statusCode = response?.statusCode;
    if (statusCode == 401) return const UnauthorizedException();
    if (statusCode == 403) return const ForbiddenException();
    if (statusCode == 500) return const ServerException();
    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.connectionError) {
      return const NetworkException();
    }
    return const UnknownException();
  }
}
```

### 3. Repository 側（呼び出し例）

```dart
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this.api);
  final ProductApi api;

  @override
  Future<Result<List<Product>>> fetchProducts() async {
    try {
      final response = await api.getProducts();
      final products = response.data
              ?.map((dto) => dto.toDomain())
              .toList() ??
          [];
      return Success(products);
    } catch (e) {
      return Failure(AppException.from(e)); // ← 統一エントリポイント
    }
  }
}
```

---

## アプローチ比較表

| 観点 | トップレベル関数 (現状) | extension 単独 | factory + extension (推奨) |
|---|:---:|:---:|:---:|
| 呼び出しの自然さ | △ `mapApiError(e)` | ◎ `e.toAppException()` | ○ `AppException.from(e)` |
| 複数エラー源への対応 | ○ | × 呼び出し側で分岐が必要 | ◎ 一箇所に集約 |
| 型ごとのロジック整理 | × 1関数に肥大化しがち | ◎ | ◎ |
| 名前空間 | △ グローバル汚染 | △ 拡張対象に依存 | ◎ `AppException` 配下 |
| 拡張性（新しいエラー源追加） | ○ 関数を分岐追加 | △ 呼び出し側も変更 | ◎ extension追加 + factory1行 |
| IDE 補完での発見しやすさ | △ | ◎ | ○ |

---

## このアプローチのメリット

1. **窓口の一本化** — 呼び出し側は `AppException.from(e)` だけを覚えればよい
2. **責務の分離** — 各エラー型の変換ロジックは、その型に対応する extension に集約
3. **拡張容易性** — Keycloak、OAS生成例外など新しいエラー源を追加する際は
   - 該当型の extension を1つ追加
   - factory の `switch` に1行追加
   だけで済む
4. **名前空間の整理** — `AppException` クラス配下に集約され、グローバル関数が増えない
5. **型安全** — `sealed class` + `switch` で分岐漏れをコンパイラが検出

---

## 将来の拡張イメージ

Keycloak と OAS自動生成の例外を追加する場合：

```dart
// 1. 各型の extension を追加
extension KeycloakExceptionMapper on KeycloakException {
  AppException toAppException() {
    // Keycloak固有の変換ロジック
    return const UnauthorizedException();
  }
}

extension ApiExceptionMapper on ApiException {
  AppException toAppException() {
    // OAS生成コードの ApiException を変換
    return switch (code) {
      401 => const UnauthorizedException(),
      403 => const ForbiddenException(),
      _ => const UnknownException(),
    };
  }
}

// 2. factory の switch に追加
factory AppException.from(Object error) => switch (error) {
  DioException e     => e.toAppException(),
  KeycloakException e => e.toAppException(),
  ApiException e      => e.toAppException(),
  _ => const UnknownException(),
};
```

呼び出し側のコードは **一切変更不要**。

---

## まとめ

- **extension は強力だが、単独では「窓口」には向かない**
- **factory constructor を入り口にし、内部で型ごとの extension に委譲する** のがバランスの良い設計
- 業務アプリで重要な「呼び出し窓口の一本化」と「変換ロジックの整理」の両立ができる
- 元の `mapApiError` 関数のシンプルさも保ちつつ、より型に寄り添った形にできる

---

## 参考

- Zenn: 「Flutter」Result型 × sealed class × AppException で実現する安全なエラーハンドリング設計
  https://zenn.dev/harx/articles/a9a5e928504e23
- 元ドキュメント: `flutterアドバイスメモ(Zenn記事統合版).docx` 項目7
