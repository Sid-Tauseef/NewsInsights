// ignore_for_file: unused_local_variable

import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client/constants/config.dart'; // Ensure this is correct
import 'package:client/providers/likedArticleProvider.dart';
import 'package:client/models/ArticlesModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<String> categories = ['Technology', 'Science', 'Sports', 'Politics'];
  final String apiUrl =
      "https://newsapi.org/v2/everything?sources=the-times-of-india&apiKey=${Config.apiKey}"; // Use the API key from config.dart

  List<Article> newsData = [];
  List<Article> newsEver = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchRandomNews();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final articles = data['articles'] as List<dynamic>;

      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          newsData = articles.map((dynamic e) => Article.fromJson(e)).toList();
        });
      }
    } else {
      throw Exception('Failed to load news data');
    }
  }

  String getRandomCategory() {
    final random = Random();
    final randomIndex = random.nextInt(categories.length);
    return categories[randomIndex];
  }

  Future<void> fetchRandomNews() async {
    // Ensure the loading state is updated safely
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      final randomCategory = getRandomCategory();
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            newsEver = data['articles']
                .map<Article>((evernew) => (Article.fromJson(evernew)))
                .toList();
            Provider.of<LikedArticlesProvider>(context, listen: false)
                .initLikedStates(newsEver.length);
          });
        }
      }
    } catch (error) {
      //ignore:avoid_print
      print('Error fetching news: $error');
    } finally {
      // Ensure the loading state is updated safely
      if (mounted) {
        setState(() {
          isLoading = false; // Ensure loading is set to false
        });
      }
    }
  }

  bool _liked = false;

  @override
  void dispose() {
    // Add any necessary cleanup or cancellation logic here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TOP NEWS'),
        centerTitle: true,
        backgroundColor: Colors.purple, // Match the overall theme
        elevation: 4.0,
      ),
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(153, 137, 133, 189),
              Color.fromARGB(198, 117, 213, 255)
            ],
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomCenter,
            stops: [0.0, 0.8],
            tileMode: TileMode.mirror,
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.blue,
              ))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overScroll) {
                          overScroll.disallowIndicator();
                          return true;
                        },
                        child: ListView.builder(
                          itemCount: newsEver.length,
                          itemBuilder: (context, index) {
                            final item = newsEver[index];
                            return InkWell(
                              onTap: () async {
                                String title = item.title;
                                String category = item.category ??
                                    'general'; // Default category

                                // Update this method call to include both title and category
                                Provider.of<LikedArticlesProvider>(context,
                                        listen: false)
                                    .addLikedArticle(title, category);

                                final url = Uri.parse(item.url);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  // ignore: avoid_print
                                  print("Can't launch $url");
                                }
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 5.0,
                                margin: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                      child: Image.network(
                                        item.urlToImage,
                                        fit: BoxFit.cover,
                                        height: 200,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            item.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                item.publishedAt,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Provider.of<LikedArticlesProvider>(
                                                              context)
                                                          .isItemLiked(index)
                                                      ? Icons.favorite
                                                      : Icons
                                                          .favorite_border_outlined,
                                                  color:
                                                      Provider.of<LikedArticlesProvider>(
                                                                  context)
                                                              .isItemLiked(
                                                                  index)
                                                          ? Colors.red
                                                          : Colors.grey,
                                                ),
                                                onPressed: () {
                                                  String title = item.title;
                                                  String category = item
                                                          .category ??
                                                      'general'; // Default to 'general'

                                                  Provider.of<LikedArticlesProvider>(
                                                          context,
                                                          listen: false)
                                                      .toggleItemLiked(
                                                          index, item);

                                                  setState(() {
                                                    _liked = !_liked;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
