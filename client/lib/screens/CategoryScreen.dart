import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:client/models/Category_model.dart'; // Ensure the path is correct
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> selectedCategories = [];
  List<String> selectedTitles = [];

  // Sample categories
  List<Category> categories = [
    Category(id: '1', name: 'Healthcare', image: 'assets/image/index1.jpg'),
    Category(id: '2', name: 'Politics', image: 'assets/image/index2.jpg'),
    Category(id: '3', name: 'Business', image: 'assets/image/index3.jpg'),
    Category(id: '4', name: 'Culture', image: 'assets/image/index4.jpg'),
    Category(id: '5', name: 'Sports', image: 'assets/image/index5.jpg'),
    Category(id: '6', name: 'Technology', image: 'assets/image/index6.jpg'),
    Category(id: '7', name: 'Nature', image: 'assets/image/index7.jpg'),
    Category(id: '8', name: 'Fashion', image: 'assets/image/index8.jpg'),
  ];

  Future<void> sendCategoriesToBackend(List<String> titles) async {
    const String backendUrl = 'https://example.com/api/interests';

    try {
      final http.Response response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'interests': titles}),
      );

      if (response.statusCode == 201) {
        print('Categories sent successfully');
      } else {
        print('Failed to send categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: height * 0.07),
                  const Center(
                    child: Text(
                      "Pick your Interests",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "We'll use this info to personalize your \n feed to recommend things you'll like.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    height: height * 0.635,
                    child: GridView.builder(
                      shrinkWrap: false,
                      scrollDirection: Axis.vertical,
                      itemCount: categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: width / (height / 3),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final category = categories[index];
                        final isSelected =
                            selectedCategories.contains(category);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              category.isSelected = !isSelected;

                              if (isSelected) {
                                selectedCategories.remove(category);
                                selectedTitles.remove(category.name);
                              } else {
                                selectedCategories.add(category);
                                selectedTitles.add(category.name);
                              }
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 4,
                                color: category.isSelected
                                    ? Colors.purple
                                    : Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                    category.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .black54, // Dark overlay for visibility
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      category.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      sendCategoriesToBackend(
                          selectedTitles); // Send selected categories to the backend
                      Navigator.pushReplacementNamed(context, 'home/');
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.purple, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
