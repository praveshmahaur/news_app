

import 'package:top_news/repository/news_repository.dart';

import '../models/news_channal_headlines_model.dart';

class NewsViewModel {

  final _repo = NewsRepository();

  Future<NewsChannalHeadlinesModel> fetchNewsChannalHeadlinesApi() async {
    final response = await _repo.fetchNewsChannalHeadlinesApi();
    return response;
  }
}