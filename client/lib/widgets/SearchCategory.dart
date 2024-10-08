import 'package:flutter/material.dart';
import 'package:client/models/Category_model.dart'; // Ensure this path is correct
import 'newsListPage.dart';

class SearchCategory extends StatefulWidget {
  const SearchCategory({super.key});

  @override
  State<SearchCategory> createState() => _SearchCategoryState();
}

class _SearchCategoryState extends State<SearchCategory> {
  List<Category> filteredCategories = []; // Corrected the type
  List<Category> categories = [
    Category(id: "1", image: "assets/image/index1.jpg", name: 'Health'),
    Category(id: "2", image: "assets/image/index2.jpg", name: 'Politics'),
    Category(id: "3", image: "assets/image/index3.jpg", name: 'Business'),
    Category(id: "4", image: "assets/image/index4.jpg", name: 'Science'),
    Category(id: "5", image: "assets/image/index5.jpg", name: 'Sports'),
    Category(id: "6", image: "assets/image/index6.jpg", name: 'Technology'),
    Category(id: "7", image: "assets/image/index7.jpg", name: 'Nature'),
    Category(
        id: "8",
        image: "assets/image/index8.jpg",
        name: 'Fashion'), // Adjusted name
  ];

  @override
  void initState() {
    filteredCategories = categories; // Initialize with all categories
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: ListView(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search categories',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black87,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.purple[100],
                  filled: true,
                ),
                onChanged: (text) {
                  setState(() {
                    filteredCategories = categories
                        .where((category) => category.name
                            .toLowerCase()
                            .contains(text.toLowerCase()))
                        .toList();
                  });
                },
              ),
              SizedBox(height: height * 0.02),
              SizedBox(
                height: height * 0.635,
                child: GridView.builder(
                  shrinkWrap: false,
                  scrollDirection: Axis.vertical,
                  itemCount: filteredCategories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: width / (height / 3),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsList(
                              category:
                                  filteredCategories[index].name.toLowerCase(),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                filteredCategories[index].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  filteredCategories[index].name,
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
            ],
          ),
        ),
      ),
    );
  }
}
