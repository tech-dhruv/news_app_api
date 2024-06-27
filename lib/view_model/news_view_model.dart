import 'package:my_news_app/models/categories_news_model.dart';
import 'package:my_news_app/models/news_channel_by_category_model.dart';
import 'package:my_news_app/models/news_channel_headlines_model.dart';
import 'package:my_news_app/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlineApi(String channelName) async {
    final response = await _rep.fetchNewsChannelHeadlineApi(channelName);
    return response;
  }

  Future<NewsChannelByCategoryModel> fetchNewsChannelByCategoryApi(String channelName, String category) async {
    final response = await _rep.fetchNewsChannelByCategoryApi(channelName, category);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }


}
