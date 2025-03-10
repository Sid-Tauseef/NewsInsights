import 'package:intl/intl.dart';

class Article {
  final String sourceName;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String? category; // Add category
  bool isLiked;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.author,
    required this.publishedAt,
    required this.sourceName,
    required this.urlToImage,
    required this.content,
    this.category, // Add category to constructor
    this.isLiked = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    String dateString = json['publishedAt'];
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    const String ImageError =
        'https://play-lh.googleusercontent.com/8LYEbSl48gJoUVGDUyqO5A0xKlcbm2b39S32xvm_h-8BueclJnZlspfkZmrXNFX2XQ';

    return Article(
      description: json['description'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      author: json['author'] ?? '',
      publishedAt: formattedDate ?? '',
      sourceName: json['source']['name'] ?? '',
      urlToImage: json['urlToImage'] ?? ImageError,
      content: json['content'] ?? '',
      category:
          json['category'] ?? 'general', // Default category if not provided
    );
  }
}
