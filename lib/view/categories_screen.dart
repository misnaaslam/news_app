import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/categories_model.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'news_article_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String categoriesName = 'general';
  bool isLoading = false;

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];

  Future<void> _updateCategory(String category) async {
    setState(() {
      isLoading = true;
      categoriesName = category;
    });
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    setState(() {
      isLoading = false;
    });
  }

  Widget buildArticleItem(Articles article) {
    DateTime dataTime = article.publishedAt != null
        ? DateTime.parse(article.publishedAt!)
        : DateTime.now();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: article.urlToImage ?? 'https://via.placeholder.com/150',
            fit: BoxFit.cover,
            placeholder: (context, url) => const SpinKitCircle(
              size: 40,
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            article.title ?? "No Title",
            style: GoogleFonts.aBeeZee(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            format.format(dataTime),
            style: GoogleFonts.aBeeZee(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("News Categories")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _updateCategory(categoriesList[index].toLowerCase()),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoriesName == categoriesList[index].toLowerCase()
                              ? Colors.pinkAccent
                              : Colors.purple[50],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                            child: Text(
                              categoriesList[index],
                              style: GoogleFonts.aBeeZee(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // News Articles
            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : FutureBuilder<CategoriesModel>(
                future: newsViewModel.fetchCategories(categoriesName),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.articles != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        final article = snapshot.data!.articles![index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsArticleScreen(
                                  image: article.urlToImage ?? '',
                                  title: article.title ?? 'No Title',
                                  date: format.format(DateTime.parse(
                                      article.publishedAt ?? DateTime.now().toString())),
                                  author: article.author ?? 'Unknown Author',
                                  details: article.description ?? 'No Description',
                                  content: article.content ?? 'No Content',
                                  source: article.source?.name ?? 'Unknown Source',
                                ),
                              ),
                            );
                          },
                          child: buildArticleItem(article),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("No articles available."),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
