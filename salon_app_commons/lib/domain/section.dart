import 'package:cloud_firestore/cloud_firestore.dart';

/// セクション（画像と解説のセット）
class Section {
  String? image;
  String? text;
  int? index;

  Section({this.image, this.text, this.index});

  factory Section.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    return Section(
      image: data['image'],
      text: data['text'],
      index: data['index'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['text'] = text;
    data['index'] = index;
    return data;
  }
}
