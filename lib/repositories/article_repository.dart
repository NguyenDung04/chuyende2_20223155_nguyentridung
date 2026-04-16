import '../models/article_model.dart';
import '../services/api_service.dart';

class ArticleRepository {
  final ApiService apiService;

  ArticleRepository({required this.apiService});

  Future<List<ArticleModel>> fetchArticles() async {
    final result = await apiService.getPosts();
    return result.map((e) => ArticleModel.fromJson(e)).toList();
  }
}