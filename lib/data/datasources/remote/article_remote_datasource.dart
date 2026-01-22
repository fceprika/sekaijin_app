import 'package:dio/dio.dart';

import '../../models/api_response.dart';
import '../../models/article_model.dart';

abstract class ArticleRemoteDatasource {
  Future<ApiResponse<List<ArticleModel>>> getArticles({
    int? countryId,
    String? category,
    int page = 1,
    int perPage = 15,
  });

  Future<ArticleModel> getArticleBySlug(String slug);
}

class ArticleRemoteDatasourceImpl implements ArticleRemoteDatasource {
  final Dio _dio;

  ArticleRemoteDatasourceImpl(this._dio);

  @override
  Future<ApiResponse<List<ArticleModel>>> getArticles({
    int? countryId,
    String? category,
    int page = 1,
    int perPage = 15,
  }) async {
    final queryParams = <String, dynamic>{
      'status': 'published',
      'page': page,
      'per_page': perPage,
    };

    if (countryId != null) queryParams['country_id'] = countryId;
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }

    final response = await _dio.get(
      '/articles',
      queryParameters: queryParams,
    );

    return ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        if (data is List) {
          return data
              .map((item) => ArticleModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <ArticleModel>[];
      },
    );
  }

  @override
  Future<ArticleModel> getArticleBySlug(String slug) async {
    final response = await _dio.get('/articles/$slug');
    final data = response.data as Map<String, dynamic>;

    if (data['data'] != null) {
      return ArticleModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    return ArticleModel.fromJson(data);
  }
}
