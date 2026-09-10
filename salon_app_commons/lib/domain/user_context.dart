/// ユーザーコンテキスト - OSやIDEなどの基本情報
class UserContext {
  final String? os;
  final String? chip;
  final String? ide;
  final DateTime? lastUpdated;

  UserContext({
    this.os,
    this.chip,
    this.ide,
    this.lastUpdated,
  });

  factory UserContext.fromJson(Map<String, dynamic> json) {
    return UserContext(
      os: json['os'],
      chip: json['chip'],
      ide: json['ide'],
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'os': os,
      'chip': chip,
      'ide': ide,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  /// 必要な情報が揃っているかチェック
  bool get isComplete => os != null && ide != null && (os != 'mac' || chip != null);

  /// 不足している情報のリスト
  List<String> get missingFields {
    final missing = <String>[];
    if (os == null) missing.add('os');
    if (os == 'mac' && chip == null) missing.add('chip');
    if (ide == null) missing.add('ide');
    return missing;
  }

  UserContext copyWith({
    String? os,
    String? chip,
    String? ide,
    DateTime? lastUpdated,
  }) {
    return UserContext(
      os: os ?? this.os,
      chip: chip ?? this.chip,
      ide: ide ?? this.ide,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}