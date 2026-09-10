extension StringEx on String {
  /// 文字を省略する
  String omit(int end) {
    return length > end ? '${substring(0, end)}...' : this;
  }

  String? extractURL() {
    RegExp regex =
        RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    final match = regex.firstMatch(this);

    if (match == null) {
      return null;
    }
    return match.group(0)!;
  }
}
