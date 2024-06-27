import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_news_app/models/categories_news_model.dart';
import 'package:my_news_app/models/news_channel_by_category_model.dart';
import 'package:my_news_app/models/news_channel_headlines_model.dart';

class NewsRepository {
  String API_KEY = '4dc928d913a941a392d5f8a1f615c935';

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlineApi(
      String channelName) async {
    String url;
    if (channelName == 'general') {
       url = 'https://newsapi.org/v2/everything?q=general&apiKey=${API_KEY}';
    } else {
       url = 'https://newsapi.org/v2/everything?q=general&sources=${channelName}&apiKey=${API_KEY}';
    }
    //'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=4dc928d913a941a392d5f8a1f615c935';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<NewsChannelByCategoryModel> fetchNewsChannelByCategoryApi(
      String channelName, String category) async {
    String url;
    if (channelName == 'general') {
      url = 'https://newsapi.org/v2/everything?q=general&apiKey=${API_KEY}';
    } else {
      url = 'https://newsapi.org/v2/everything?q=${category}&sources=${channelName}&apiKey=${API_KEY}';
    }
    //'https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=4dc928d913a941a392d5f8a1f615c935';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelByCategoryModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=${API_KEY}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }

}
