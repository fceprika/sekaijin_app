import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/data/models/api_response.dart';
import 'package:sekaijin_app/domain/entities/article.dart';
import 'package:sekaijin_app/domain/entities/country.dart';
import 'package:sekaijin_app/domain/entities/user.dart';
import 'package:sekaijin_app/domain/repositories/article_repository.dart';
import 'package:sekaijin_app/presentation/providers/articles_provider.dart';
import 'package:sekaijin_app/presentation/screens/news/articles_list_view.dart';

void main() {
  final mockAuthor = User(
    id: 1,
    name: 'Test Author',
    nameSlug: 'test-author',
    email: 'test@example.com',
    createdAt: DateTime.now(),
  );

  const mockCountry = Country(
    id: 1,
    nameFr: 'Japon',
    slug: 'japon',
    emoji: '🇯🇵',
  );

  final mockArticles = [
    Article(
      id: 1,
      title: 'Test Article 1',
      slug: 'test-article-1',
      summary: 'This is a test summary for article 1',
      content: '<p>Test content 1</p>',
      category: 'temoignage',
      countryId: 1,
      authorId: 1,
      status: 'published',
      readingTime: 5,
      likes: 10,
      createdAt: DateTime.now(),
      author: mockAuthor,
      country: mockCountry,
    ),
    Article(
      id: 2,
      title: 'Test Article 2',
      slug: 'test-article-2',
      summary: 'This is a test summary for article 2',
      content: '<p>Test content 2</p>',
      category: 'guide-pratique',
      countryId: 1,
      authorId: 1,
      status: 'published',
      readingTime: 8,
      likes: 25,
      createdAt: DateTime.now(),
      author: mockAuthor,
      country: mockCountry,
    ),
  ];

  Widget createScreen({
    ArticlesState? articlesState,
    String? categoryFilter,
  }) {
    return ProviderScope(
      overrides: [
        articlesListProvider.overrideWith((ref) {
          final notifier = _MockArticlesNotifier(
            ref,
            articlesState ?? const ArticlesState(),
          );
          return notifier;
        }),
        if (categoryFilter != null)
          articleCategoryFilterProvider.overrideWith((ref) => categoryFilter),
      ],
      child: const MaterialApp(
        home: Scaffold(body: ArticlesListView()),
      ),
    );
  }

  group('ArticlesListView', () {
    testWidgets('renders with screen key', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: ArticlesState(articles: mockArticles, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('articles_list')), findsOneWidget);
    });

    testWidgets('displays category chips including Tous', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: ArticlesState(articles: mockArticles, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('category_tous')), findsOneWidget);
      expect(find.text('Tous'), findsOneWidget);
    });

    testWidgets('displays temoignage category chip', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: ArticlesState(articles: mockArticles, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('category_temoignage')), findsOneWidget);
    });

    testWidgets('displays guide-pratique category chip', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: ArticlesState(articles: mockArticles, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('category_guide-pratique')), findsOneWidget);
    });

    testWidgets('displays travail category chip', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: ArticlesState(articles: mockArticles, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('category_travail')), findsOneWidget);
    });

    testWidgets('displays lifestyle category chip', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: ArticlesState(articles: mockArticles, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('category_lifestyle')), findsOneWidget);
    });

    testWidgets('displays cuisine category chip', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: ArticlesState(articles: mockArticles, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('category_cuisine')), findsOneWidget);
    });

    testWidgets('displays article cards with correct keys', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: ArticlesState(articles: mockArticles, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('article_card_0')), findsOneWidget);
    });

    testWidgets('displays first article title', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: ArticlesState(articles: mockArticles, total: 2),
      ));
      await tester.pump();

      expect(find.text('Test Article 1'), findsOneWidget);
    });

    testWidgets('displays empty state when no articles', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: const ArticlesState(articles: [], total: 0),
      ));
      await tester.pump();

      expect(find.text('Aucun article'), findsOneWidget);
    });

    testWidgets('shows loading shimmer when loading', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: const ArticlesState(isLoading: true),
      ));
      await tester.pump();

      // Loading shimmer should be displayed
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('has RefreshIndicator for pull-to-refresh', (tester) async {
      await tester.pumpWidget(createScreen(
        articlesState: ArticlesState(articles: mockArticles, total: 2),
      ));
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}

class _MockArticlesNotifier extends ArticlesNotifier {
  final ArticlesState _mockState;

  _MockArticlesNotifier(Ref ref, this._mockState)
      : super(_MockArticleRepository(), ref);

  @override
  ArticlesState get state => _mockState;

  @override
  Future<void> loadArticles() async {}

  @override
  Future<void> loadMore() async {}

  @override
  Future<void> refresh() async {}
}

class _MockArticleRepository implements ArticleRepository {
  @override
  Future<(Failure?, ApiResponse<List<Article>>?)> getArticles({
    int? countryId,
    String? category,
    int page = 1,
    int perPage = 15,
  }) async =>
      (null, null);

  @override
  Future<(Failure?, Article?)> getArticleBySlug(String slug) async =>
      (null, null);
}
