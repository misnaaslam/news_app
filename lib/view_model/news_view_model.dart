import 'package:news_app/controller/news_repository.dart';
import 'package:news_app/model/categories_model.dart';
import 'package:news_app/model/news_headline_model.dart';

class NewsViewModel {
  final NewsRepository _repository = NewsRepository();

  Future<NewsHeadlineDataModel> fetchNewsHeadline(String newsChannel) async {
    final response = await _repository.fetchNewsHeadline(newsChannel);
    return response;
  }
  Future<CategoriesModel> fetchCategories(String categories) async {
    final response = await _repository.fetchCategories(categories);
    return response;
  }
}
