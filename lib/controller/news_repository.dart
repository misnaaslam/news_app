import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/model/news_headline_model.dart';

import '../model/categories_model.dart';

class NewsRepository {

  Future<NewsHeadlineDataModel> fetchNewsHeadline(String newsChannel) async {
    String newsUrl = 'https://newsapi.org/v2/top-headlines?sources=${newsChannel}&apiKey=08fb462dd3cb463a92fe7598a135578e';
    print(newsUrl);
    final response = await http.get(Uri.parse(newsUrl));
    print(response.statusCode.toString());
    print(response);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print(response.body);
      return NewsHeadlineDataModel.fromJson(body);
    } else {
      throw Exception('Failed to load news headlines');
    }
  }

  Future<CategoriesModel> fetchCategories(String categories) async {
    String newsUrl = 'https://newsapi.org/v2/everything?q=${categories}&apiKey=08fb462dd3cb463a92fe7598a135578e';
    print(newsUrl);
    final response = await http.get(Uri.parse(newsUrl));
    print(response.statusCode.toString());
    print(response);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print(response.body);
      return CategoriesModel.fromJson(body);
    } else {
      throw Exception('Failed to load news headlines');
    }
  }
}
