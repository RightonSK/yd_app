/// 開発実績
///
/// Flutter大学メンバーの開発実績
///
/// 開発したものがアプリとは限らなないため汎用的なパラメータを持たせることとする。
///
/// ポートフォリオの一部として使用する
class DevelopmentResult {
  DevelopmentResult({
    required this.title,
    required this.description,
    required this.url,
  });

  factory DevelopmentResult.fromMap(Map<String, dynamic> map) {
    return DevelopmentResult(
      title: map['title'],
      description: map['description'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
    };
  }

  final String title;
  final String description;
  final String url;

  @override
  int get hashCode {
    return title.hashCode ^ description.hashCode ^ url.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is DevelopmentResult && hashCode == other.hashCode;
  }
}
