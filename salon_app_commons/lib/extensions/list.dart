extension ListEx<E> on List {
  /// 次の要素を返す
  E next(int cur) {
    final index = cur + 1;
    return (index < 0 || length <= index) ? null : this[index];
  }

  /// 前の要素を返す
  E before(int cur) {
    final index = cur - 1;
    return (index < 0 || length <= index) ? null : this[index];
  }
}
