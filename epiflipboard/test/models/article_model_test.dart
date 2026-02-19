import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/models/articleResult.dart';

void main() {
  group('Article Model', () {
    test('fromJson returns valid Article', () {
      final Map<String, dynamic> json = {
        'title': 'Test Title',
        'source': {'name': 'Test Source'},
        'urlToImage': 'http://image.com/img.png',
        'url': 'http://article.com',
      };
      final article = Article.fromJson(json);
      expect(article.title, 'Test Title');
      expect(article.source, 'Test Source');
      expect(article.imageUrl, 'http://image.com/img.png');
      expect(article.url, 'http://article.com');
    });

    test('fromJson handles missing fields', () {
      final Map<String, dynamic> json = {};
      final article = Article.fromJson(json);
      expect(article.title, '');
      expect(article.source, '');
      expect(article.imageUrl, contains('No+Image'));
      expect(article.url, '');
    });
  });
}
