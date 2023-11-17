import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/news_channal_headlines_model.dart';

class NewsRepository{

  Future<NewsChannalHeadlinesModel> fetchNewsChannalHeadlinesApi() async{

    String url= 'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=44b70f9076d9421684605ea51020cd36';

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode==200){
      final body = jsonDecode(response.body);
      return NewsChannalHeadlinesModel.fromJson(body);
    }
    throw Exception("Error");

  }



}