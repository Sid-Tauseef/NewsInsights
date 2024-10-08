import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/widgets/theme.dart'; // Ensure this points to the correct theme file
import 'package:client/providers/likedArticleProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:client/constants/config.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  List<Map<String, dynamic>> _recommendedArticles = [];
  bool isLoading = false;
  bool _isSearching = false; // If user is searching
  bool _hasError = false; // Track errors

  // Function to get recommendations
  Future<void> _getRecommendations(BuildContext context) async {
    setState(() {
      isLoading = true;
      _hasError = false;
    });

    List<String> likedArticles =
        Provider.of<LikedArticlesProvider>(context, listen: false)
            .likedArticles;

    // If no liked articles, display message
    if (likedArticles.isEmpty) {
      setState(() {
        _hasError = true;
        isLoading = false;
      });
      return;
    }

    String apiUrl = '${Config.url}/recommend_news/'; // Use Config.url

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"likedArticles": likedArticles}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is List &&
            jsonResponse.every((element) =>
                element is Map &&
                element.containsKey('title') &&
                element.containsKey('description'))) {
          setState(() {
            _recommendedArticles =
                List<Map<String, dynamic>>.from(jsonResponse);
            _isSearching = false;
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load recommendations');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getRecommendations(context); // Fetch recommendations when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Articles'),
        backgroundColor: AppTheme.primaryColor, // Use your theme color
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
          : _hasError
              ? const Center(
                  child: Text(
                    'No recommendations available or an error occurred.',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : _recommendedArticles.isEmpty
                  ? const Center(
                      child: Text(
                        'No recommendations yet. Like some articles to get recommendations!',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _recommendedArticles.length,
                              itemBuilder: (context, index) {
                                final article = _recommendedArticles[index];
                                return InkWell(
                                  onTap: () async {
                                    final url = Uri.parse(article['url']);
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    } else {
                                      print("Can't launch $url");
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide.none,
                                      ),
                                      elevation: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (article
                                                  .containsKey('urlToImage') &&
                                              article['urlToImage'] != null)
                                            Image.network(
                                              article['urlToImage'],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 200,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Center(
                                                    child: Text(
                                                        'Image not available'));
                                              },
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  article['title'] ??
                                                      'No Title',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  article['description'] ?? '',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
