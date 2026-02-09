import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/articleResult.dart';
import '../config/newsApi.dart';


class NewsApiService {
  Future<List<dynamic>> searchKeyword(String keyword) async {
    final url = Uri.parse(
      "https://newsapi.org/v2/everything"
      "?q=$keyword"
      "&apiKey=$newsApiKey",
    );


    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["articles"];
    } else {
      throw Exception("Erreur NewsAPI : ${response.statusCode}");
    }
  }

  Future<List<dynamic>> searchTopic(String topic) async {
    final url = Uri.parse(
      "https://newsapi.org/v2/top-headlines"
      "?category=$topic"
      "&language=fr"
      "&apiKey=$newsApiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["articles"];
    } else {
      throw Exception("Erreur NewsAPI - topic");
    }
  }

  static Future<List<Article>> searchArticles(String query) async {
    final url = Uri.parse(
      "https://newsapi.org/v2/everything"
      "?q=$query"
      "&apiKey=$newsApiKey",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur NewsAPI");
    }

    final data = jsonDecode(response.body);
    final List articlesJson = data["articles"];

    return articlesJson
        .map((json) => Article.fromJson(json))
        .toList();
  }

}
