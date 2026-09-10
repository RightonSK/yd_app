import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webfeed_plus/webfeed_plus.dart';

import '../domain/article.dart';

class NewsRssRepository {
  static NewsRssRepository? _instance;
  NewsRssRepository._internal();

  factory NewsRssRepository() {
    return _instance ??= NewsRssRepository._internal();
  }

  // RSSでFlutterニュースを取得する
  // wordpressの設定で10件になっている場合は10件
  Future<List<Article>> fetchFlutterNews() async {
    final url = Uri.parse('https://blog.flutteruniv.com/rss.xml');
    final response = await http.get(url);
    final body = utf8.decode(response.bodyBytes);
    final feed = RssFeed.parse(body);
    final items = feed.items!;
    final articles = items
        .map((item) => Article(
              link: item.link ?? '',
              title: item.title ?? '',
              image: item.content?.images.first ?? '',
              createdAt: item.pubDate ?? DateTime.now(),
            ))
        .toList();
    return articles;
  }

  Future<List<Article>> fetchFlutterZennFeed() async {
    final url = Uri.parse('https://zenn.dev/topics/flutter/feed');
    final response = await http.get(url);
    final body = utf8.decode(response.bodyBytes);
    final feed = RssFeed.parse(body);
    final items = feed.items!;
    final articles = items
        .map((item) => Article(
              link: item.link ?? '',
              title: item.title ?? '',
              image: item.enclosure?.url ?? '',
              createdAt: item.pubDate ?? DateTime.now(),
            ))
        .toList();
    return articles;
  }
}
