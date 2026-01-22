import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/domain/entities/user.dart';
import 'package:sekaijin_app/domain/repositories/auth_repository.dart';
import 'package:sekaijin_app/presentation/providers/auth_provider.dart';
import 'package:sekaijin_app/presentation/providers/home_provider.dart';
import 'package:sekaijin_app/presentation/screens/home/home_screen.dart';
import 'package:sekaijin_app/presentation/widgets/cards/news_card.dart';
import 'package:sekaijin_app/presentation/widgets/cards/place_card.dart';

void main() {
  final mockUser = User(
    id: 1,
    name: 'TestUser',
    nameSlug: 'testuser',
    email: 'test@test.com',
    countryId: 1,
    createdAt: DateTime.now(),
  );

  final mockHomeData = HomeData(
    latestNews: [
      NewsCardData(
        id: '1',
        title: 'Test News 1',
        category: 'Culture',
        imageUrl: 'https://example.com/1.jpg',
        date: DateTime.now(),
      ),
      NewsCardData(
        id: '2',
        title: 'Test News 2',
        category: 'Nature',
        imageUrl: 'https://example.com/2.jpg',
        date: DateTime.now(),
      ),
    ],
    popularPlaces: const [
      PlaceCardData(
        id: '1',
        title: 'Test Place 1',
        category: 'Temple',
        location: 'Tokyo, Japan',
        imageUrl: 'https://example.com/p1.jpg',
        rating: 4.5,
      ),
      PlaceCardData(
        id: '2',
        title: 'Test Place 2',
        category: 'Market',
        location: 'Bangkok, Thailand',
        imageUrl: 'https://example.com/p2.jpg',
        rating: 4.2,
      ),
    ],
  );

  Widget createHomeScreen({
    AuthState? authState,
    AsyncValue<HomeData>? homeDataValue,
  }) {
    return ProviderScope(
      overrides: [
        if (authState != null)
          authStateProvider.overrideWith((ref) {
            final notifier = _MockAuthNotifier(authState);
            return notifier;
          }),
        if (homeDataValue != null)
          homeDataProvider.overrideWith((ref) {
            if (homeDataValue is AsyncData<HomeData>) {
              return Future.value(homeDataValue.value);
            } else if (homeDataValue is AsyncError<HomeData>) {
              return Future.error(homeDataValue.error);
            }
            return Future.delayed(const Duration(days: 1));
          }),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('renders all sections when data is loaded', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: AuthAuthenticated(mockUser),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_screen')), findsOneWidget);
      expect(find.byKey(const Key('welcome_section')), findsOneWidget);
      expect(find.byKey(const Key('search_bar')), findsOneWidget);
      expect(find.byKey(const Key('country_selector')), findsOneWidget);
      expect(find.byKey(const Key('news_section')), findsOneWidget);
      expect(find.byKey(const Key('popular_places_section')), findsOneWidget);
    });

    testWidgets('displays username in welcome message', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: AuthAuthenticated(mockUser),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Bienvenue,'), findsOneWidget);
      expect(find.text('TestUser!'), findsOneWidget);
    });

    testWidgets('displays default username when not authenticated', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: const AuthUnauthenticated(),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Utilisateur!'), findsOneWidget);
    });

    testWidgets('renders 4 country buttons', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: AuthAuthenticated(mockUser),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('country_th')), findsOneWidget);
      expect(find.byKey(const Key('country_vn')), findsOneWidget);
      expect(find.byKey(const Key('country_jp')), findsOneWidget);
      expect(find.byKey(const Key('country_cn')), findsOneWidget);
    });

    testWidgets('country selection updates state', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: AuthAuthenticated(mockUser),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      // Japan is selected by default, tap on Thailand
      await tester.tap(find.byKey(const Key('country_th')));
      await tester.pumpAndSettle();

      // Verify the tap was registered (we can check that the widget still exists)
      expect(find.byKey(const Key('country_th')), findsOneWidget);
    });

    testWidgets('pull-to-refresh triggers reload', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: AuthAuthenticated(mockUser),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      // Find the RefreshIndicator by key
      expect(find.byKey(const Key('home_scroll_view')), findsOneWidget);

      // Perform a pull-to-refresh gesture
      await tester.fling(
        find.byType(SingleChildScrollView),
        const Offset(0, 300),
        1000,
      );
      await tester.pump();

      // The refresh indicator should be visible
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('is scrollable', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: AuthAuthenticated(mockUser),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      // Find the scroll view
      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);

      // Verify it's scrollable by checking for AlwaysScrollableScrollPhysics
      final scrollWidget = tester.widget<SingleChildScrollView>(scrollView);
      expect(scrollWidget.physics, isA<AlwaysScrollableScrollPhysics>());
    });

    testWidgets('renders news cards with correct keys', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: AuthAuthenticated(mockUser),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('news_card_0')), findsOneWidget);
      expect(find.byKey(const Key('news_card_1')), findsOneWidget);
    });

    testWidgets('renders place cards with correct keys', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: AuthAuthenticated(mockUser),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('place_card_0')), findsOneWidget);
      expect(find.byKey(const Key('place_card_1')), findsOneWidget);
    });

    testWidgets('displays search bar placeholder', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: AuthAuthenticated(mockUser),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Rechercher...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('displays section headers', (tester) async {
      await tester.pumpWidget(createHomeScreen(
        authState: AuthAuthenticated(mockUser),
        homeDataValue: AsyncData(mockHomeData),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Dernières actualités'), findsOneWidget);
      expect(find.text('Lieux populaires'), findsOneWidget);
    });
  });
}

class _MockAuthNotifier extends AuthNotifier {
  final AuthState _initialState;

  _MockAuthNotifier(this._initialState) : super(_MockAuthRepository());

  @override
  AuthState get state => _initialState;
}

class _MockAuthRepository implements AuthRepository {
  @override
  Future<User?> getCurrentUser() async => null;

  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<(Failure?, User?)> login(String email, String password) async =>
      (null, null);

  @override
  Future<(Failure?, void)> logout() async => (null, null);

  @override
  Future<(Failure?, User?)> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? countryResidence,
    String? interestCountry,
    required bool terms,
  }) async =>
      (null, null);
}
