extension ListX<E> on List<E> {
  /// [index]を指定して要素を返します。
  /// [index]が[List]の範囲外だった場合[defaultValue]を返します。
  /// [defaultValue]を指定しない場合[null]を返します。

  // 実装はdart:coreのelementAtを参考にしました。
  E? elementAtSafely(int index, [E? defaultValue]) {
    if (index < 0) return defaultValue;
    int elementIndex = 0;
    for (E element in this) {
      if (index == elementIndex) return element;
      elementIndex++;
    }
    return defaultValue;
  }
}
