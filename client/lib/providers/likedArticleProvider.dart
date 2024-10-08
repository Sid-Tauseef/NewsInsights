// liked_articles_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import "package:client/models/ArticlesModel.dart";

class LikedArticlesProvider extends ChangeNotifier {
  final List<String> _likedArticles = [];
  List<bool> _likedStates = [];

  String userEmail =
      'user@example.com'; // Assuming user email is stored locally

  // Initialize liked states based on the number of articles
  void initLikedStates(int length) {
    _likedStates = List.filled(length, false);
    notifyListeners();
  }

  List<String> get likedArticles => _likedArticles;

  // Add an article to liked list and update the backend
  Future<void> addLikedArticle(
      String articleTitle, String articleCategory) async {
    if (!_likedArticles.contains(articleTitle)) {
      _likedArticles.add(articleTitle);

      // Send liked article to the backend
      final response = await http.post(
        Uri.parse('http://localhost:3000/likeArticle'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": userEmail,
          "articleTitle": articleTitle,
          "articleCategory": articleCategory,
        }),
      );

      if (response.statusCode == 200) {
        print('Article liked successfully');
      } else {
        print('Failed to like article');
      }
    }

    notifyListeners();
  }

  // Remove an article from liked list
  void removeArticle(String articleTitle) {
    _likedArticles.remove(articleTitle);
    notifyListeners();
  }

  // Check if the article is liked
  bool isItemLiked(int index) {
    return _likedStates[index];
  }

  // Toggle the liked state of an article
  void toggleItemLiked(int index, Article article) {
    _likedStates[index] = !_likedStates[index];

    if (_likedStates[index]) {
      addLikedArticle(article.title,
          article.category ?? 'general'); // Ensure two parameters
    } else {
      removeArticle(article.title);
    }
    notifyListeners();
  }

  // Fetch recommendations based on liked articles
  Future<List<Article>> fetchRecommendations() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/getRecommendations'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": userEmail}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final recommendedArticles = data['data'] as List<dynamic>;
      return recommendedArticles
          .map((dynamic e) => Article.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}
