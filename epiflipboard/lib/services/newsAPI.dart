import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  final String apiKey = "APIKEY";

  Future<List<dynamic>> searchKeyword(String keyword) async {
    final url = Uri.parse(
      "https://newsapi.org/v2/everything?q=$keyword&pageSize=3&apiKey=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["articles"];
    } else {
      throw Exception("Erreur NewsAPI : ${response.statusCode}");
    }
  }
}
