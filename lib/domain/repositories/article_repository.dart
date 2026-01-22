import '../../core/errors/failures.dart';
import '../../data/models/api_response.dart';
import '../entities/article.dart';

abstract class ArticleRepository {
  Future<(Failure?, ApiResponse<List<Article>>?)> getArticles({
    int? countryId,
    String? category,
    int page = 1,
    int perPage = 15,
  });

  Future<(Failure?, Article?)> getArticleBySlug(String slug);
}
