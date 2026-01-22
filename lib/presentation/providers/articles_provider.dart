import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/article_remote_datasource.dart';
import '../../data/repositories/article_repository_impl.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import 'auth_provider.dart';

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

// Articles state
class ArticlesState {
  final List<Article> articles;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final int total;
  final String? error;

  const ArticlesState({
    this.articles = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.total = 0,
    this.error,
  });

  ArticlesState copyWith({
    List<Article>? articles,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    int? total,
    String? error,
  }) {
    return ArticlesState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
      error: error,
    );
  }
}

// Articles notifier
class ArticlesNotifier extends StateNotifier<ArticlesState> {
  final ArticleRepository _repository;
  final Ref _ref;

  ArticlesNotifier(this._repository, this._ref) : super(const ArticlesState()) {
    _init();
  }

  void _init() {
    // Listen to filter changes
    _ref.listen(articleCategoryFilterProvider, (_, __) => refresh());

    // Initial load
    loadArticles();
  }

  Future<void> loadArticles() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    final category = _ref.read(articleCategoryFilterProvider);

    final (failure, response) = await _repository.getArticles(
      category: category,
      page: 1,
    );

    if (failure != null) {
      state = state.copyWith(
        isLoading: false,
        error: failure.message,
      );
      return;
    }

    if (response != null) {
      state = state.copyWith(
        articles: response.data ?? [],
        isLoading: false,
        currentPage: response.pagination?.currentPage ?? 1,
        hasMore: response.pagination?.hasMorePages ?? false,
        total: response.pagination?.total ?? 0,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    final category = _ref.read(articleCategoryFilterProvider);
    final nextPage = state.currentPage + 1;

    final (failure, response) = await _repository.getArticles(
      category: category,
      page: nextPage,
    );

    if (failure != null) {
      state = state.copyWith(
        isLoadingMore: false,
        error: failure.message,
      );
      return;
    }

    if (response != null) {
      final newArticles = <Article>[...state.articles, ...(response.data ?? [])];
      state = state.copyWith(
        articles: newArticles,
        isLoadingMore: false,
        currentPage: response.pagination?.currentPage ?? nextPage,
        hasMore: response.pagination?.hasMorePages ?? false,
      );
    }
  }

  Future<void> refresh() async {
    state = const ArticlesState();
    await loadArticles();
  }
}

// Articles list provider
final articlesListProvider = StateNotifierProvider<ArticlesNotifier, ArticlesState>((ref) {
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
