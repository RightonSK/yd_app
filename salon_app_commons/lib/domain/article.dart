import 'content.dart';

class Article extends Content {
  @override
  final String id = '';

  final String link;

  @override
  final String title;

  @override
  final String image;

  @override
  final DateTime createdAt;

  Article({
    required this.link,
    required this.title,
    required this.image,
    required this.createdAt,
  });
}
