import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/news_headline_model.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/login_screen.dart';
import 'package:news_app/view/news_article_screen.dart';
import 'package:news_app/view/profile_screen.dart';

import 'package:news_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/categories_model.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  FilterList? selectedMenu;
  final NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';

  get username => widget.username;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Headlines'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoriesScreen()),
            );
          },
          icon: const Icon(Icons.list_rounded),
        ),
        actions: <Widget>[
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item) {
              setState(() {
                selectedMenu = item;
                if (item == FilterList.bbcNews) {
                  name = 'bbc-news';
                } else if (item == FilterList.alJazeera) {
                  name = 'al-jazeera-english';
                } else if (item == FilterList.cnn) {
                  name = 'cnn';
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              const PopupMenuItem(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              const PopupMenuItem(
                value: FilterList.alJazeera,
                child: Text('AlJazeera'),
              ),
              const PopupMenuItem(
                value: FilterList.cnn,
                child: Text('CNN'),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            // News Headlines Section
            FutureBuilder<NewsHeadlineDataModel>(
              future: newsViewModel.fetchNewsHeadline(name),
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
                } else
                  if (snapshot.hasData &&
                    snapshot.data!.articles != null &&
                    snapshot.data!.articles!.isNotEmpty) {
                  return SizedBox(
                    height: height * 0.4,
                    child: ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime dataTime = DateTime.parse(
                          snapshot.data!.articles![index].publishedAt ?? '',
                        );
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsArticleScreen(
                                  image: snapshot
                                      .data!.articles![index].urlToImage ??
                                      '',
                                  title: snapshot
                                      .data!.articles![index].title ??
                                      'No Title',
                                  date: format.format(dataTime),
                                  author: snapshot
                                      .data!.articles![index].author ??
                                      'Unknown Author',
                                  details: snapshot
                                      .data!.articles![index].description ??
                                      'No Description',
                                  content: snapshot
                                      .data!.articles![index].content ??
                                      'No Content',
                                  source: snapshot
                                      .data!.articles![index].source?.name ??
                                      'Unknown Source',
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SizedBox(
                                  width: width * 1.5,
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage ??
                                        '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                    const SpinKitCircle(
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: width * 0.4,
                                    padding: const EdgeInsets.all(12),
                                    color: Colors.black.withOpacity(0.5),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              ?.toString() ??
                                              '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                snapshot.data!
                                                    .articles![index].source
                                                    ?.name ??
                                                    '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              format.format(dataTime),
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
            // Categories Section
            FutureBuilder<CategoriesModel>(
              future: newsViewModel.fetchCategories('General'),
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
                } else if (snapshot.hasData &&
                    snapshot.data!.articles != null &&
                    snapshot.data!.articles!.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: height * 0.5,
                      child: ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime dataTime = DateTime.parse(
                            snapshot.data!.articles![index].publishedAt ?? '',
                          );
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsArticleScreen(
                                    image: snapshot
                                        .data!.articles![index].urlToImage ??
                                        '',
                                    title: snapshot
                                        .data!.articles![index].title ??
                                        'No Title',
                                    date: format.format(dataTime),
                                    author: snapshot
                                        .data!.articles![index].author ??
                                        'Unknown Author',
                                    details: snapshot
                                        .data!.articles![index].description ??
                                        'No Description',
                                    content: snapshot
                                        .data!.articles![index].content ??
                                        'No Content',
                                    source: snapshot
                                        .data!.articles![index].source?.name ??
                                        'Unknown Source',
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SizedBox(
                                  height: height * 0.2,
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage ??
                                        '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                    const SpinKitCircle(
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: width * 0.9,
                                    padding: const EdgeInsets.all(12),
                                    color: Colors.black.withOpacity(0.5),
                                    child: Text(
                                      snapshot.data!.articles![index].title
                                          ?.toString() ??
                                          '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(username: widget.username),
            ),
          );
        },
        child: const Icon(Icons.person_outline),
      ),
    );
  }
}
