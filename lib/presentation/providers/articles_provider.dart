import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/article_remote_datasource.dart';
import '../../data/repositories/article_repository_impl.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import 'auth_provider.dart';
import 'paged_state.dart';

// Filter provider
final articleCategoryFilterProvider = StateProvider<String?>((ref) => null);

// Datasource and repository providers
final articleRemoteDatasourceProvider = Provider<ArticleRemoteDatasource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ArticleRemoteDatasourceImpl(apiService.dio);
});

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  final remoteDatasource = ref.watch(articleRemoteDatasourceProvider);
  return ArticleRepositoryImpl(remoteDatasource);
});

// Articles notifier
class ArticlesNotifier extends PagedNotifier<Article> {
  final Ref _ref;

  ArticlesNotifier(ArticleRepository repository, this._ref)
      : super(
          (page) => repository.getArticles(
            category: _ref.read(articleCategoryFilterProvider),
            page: page,
          ),
        ) {
    _init();
  }

  void _init() {
    // Listen to filter changes
    _ref.listen(articleCategoryFilterProvider, (_, __) => refresh());

    // Initial load
    loadInitial();
  }
}

// Articles list provider
final articlesListProvider = StateNotifierProvider<ArticlesNotifier, PagedState<Article>>((ref) {
  final repository = ref.watch(articleRepositoryProvider);
  return ArticlesNotifier(repository, ref);
});

// Article detail provider
final articleDetailProvider = FutureProvider.family<Article?, String>((ref, slug) async {
  final repository = ref.watch(articleRepositoryProvider);
  final (failure, article) = await repository.getArticleBySlug(slug);

  if (failure != null) {
    throw Exception(failure.message);
  }

  return article;
});
