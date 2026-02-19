import 'package:flutter_test/flutter_test.dart';
import 'package:epiflipboard/services/newsAPI.dart';
import 'package:epiflipboard/models/article.dart';

void main() {
  group('NewsApiService', () {
    test('getArticlesByTopic returns List<Article>', () async {
      final articles = await NewsApiService.getArticlesByTopic('tech');
      expect(articles, isA<List<Article>>());
    });
    test('searchArticles returns List<Article>', () async {
      final articles = await NewsApiService.searchArticles('flutter');
      expect(articles, isA<List<Article>>());
    });
    test('getLatestArticles returns List<Article>', () async {
      final articles = await NewsApiService.getLatestArticles();
      expect(articles, isA<List<Article>>());
    });
  });
}
