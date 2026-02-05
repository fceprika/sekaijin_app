import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sekaijin_app/core/errors/failures.dart';
import 'package:sekaijin_app/data/models/api_response.dart';
import 'package:sekaijin_app/domain/entities/event.dart';
import 'package:sekaijin_app/domain/entities/user.dart';
import 'package:sekaijin_app/domain/repositories/event_repository.dart';
import 'package:sekaijin_app/presentation/providers/events_provider.dart';
import 'package:sekaijin_app/presentation/providers/paged_state.dart';
import 'package:sekaijin_app/presentation/screens/news/events_list_view.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR', null);
  });

  final mockOrganizer = User(
    id: 1,
    name: 'Test Organizer',
    nameSlug: 'test-organizer',
    email: 'test@example.com',
    createdAt: DateTime.now(),
  );

  final mockEvents = [
    Event(
      id: 1,
      title: 'Test Event 1',
      slug: 'test-event-1',
      description: 'Description for event 1',
      category: 'meetup',
      countryId: 1,
      organizerId: 1,
      status: 'published',
      startDate: DateTime.now().add(const Duration(days: 7)),
      isOnline: false,
      location: 'Paris',
      price: 0,
      currentParticipants: 5,
      maxParticipants: 20,
      createdAt: DateTime.now(),
      organizer: mockOrganizer,
    ),
    Event(
      id: 2,
      title: 'Test Event 2',
      slug: 'test-event-2',
      description: 'Description for event 2',
      category: 'workshop',
      countryId: 1,
      organizerId: 1,
      status: 'published',
      startDate: DateTime.now().add(const Duration(days: 14)),
      isOnline: true,
      price: 25,
      currentParticipants: 10,
      createdAt: DateTime.now(),
      organizer: mockOrganizer,
    ),
  ];

  Widget createScreen({
    PagedState<Event>? eventsState,
    bool? onlineFilter,
  }) {
    return ProviderScope(
      overrides: [
        eventsListProvider.overrideWith((ref) {
          final notifier = _MockEventsNotifier(
            ref,
            eventsState ?? const PagedState<Event>(),
          );
          return notifier;
        }),
        if (onlineFilter != null)
          eventOnlineFilterProvider.overrideWith((ref) => onlineFilter),
      ],
      child: const MaterialApp(
        home: Scaffold(body: EventsListView()),
      ),
    );
  }

  group('EventsListView', () {
    testWidgets('renders with screen key', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: PagedState<Event>(items: mockEvents, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('events_list')), findsOneWidget);
    });

    testWidgets('displays filter toggles', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: PagedState<Event>(items: mockEvents, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('event_filter_all')), findsOneWidget);
      expect(find.byKey(const Key('event_filter_online')), findsOneWidget);
      expect(find.byKey(const Key('event_filter_presentiel')), findsOneWidget);
    });

    testWidgets('displays Tous filter text', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: PagedState<Event>(items: mockEvents, total: 2),
      ));
      await tester.pump();

      expect(find.text('Tous'), findsOneWidget);
    });

    testWidgets('displays En ligne filter text', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: PagedState<Event>(items: mockEvents, total: 2),
      ));
      await tester.pump();

      expect(find.text('En ligne'), findsWidgets);
    });

    testWidgets('displays event cards with correct keys', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: PagedState<Event>(items: mockEvents, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('event_card_0')), findsOneWidget);
    });

    testWidgets('event cards have date keys', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: PagedState<Event>(items: mockEvents, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('event_date_0')), findsOneWidget);
    });

    testWidgets('event cards have title keys', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: PagedState<Event>(items: mockEvents, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('event_title_0')), findsOneWidget);
    });

    testWidgets('event cards have location keys', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: PagedState<Event>(items: mockEvents, total: 2),
      ));
      await tester.pump();

      expect(find.byKey(const Key('event_location_0')), findsOneWidget);
    });

    testWidgets('displays event title', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: PagedState<Event>(items: mockEvents, total: 2),
      ));
      await tester.pump();

      expect(find.text('Test Event 1'), findsOneWidget);
    });

    testWidgets('displays empty state when no events', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: const PagedState<Event>(items: [], total: 0),
      ));
      await tester.pump();

      expect(find.text('Aucun événement'), findsOneWidget);
    });

    testWidgets('has RefreshIndicator for pull-to-refresh', (tester) async {
      await tester.pumpWidget(createScreen(
        eventsState: PagedState<Event>(items: mockEvents, total: 2),
      ));
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}

class _MockEventsNotifier extends EventsNotifier {
  final PagedState<Event> _mockState;

  _MockEventsNotifier(Ref ref, this._mockState)
      : super(_MockEventRepository(), ref);

  @override
  PagedState<Event> get state => _mockState;

  @override
  Future<void> loadInitial() async {}

  @override
  Future<void> loadMore() async {}

  @override
  Future<void> refresh() async {}
}

class _MockEventRepository implements EventRepository {
  @override
  Future<(Failure?, ApiResponse<List<Event>>?)> getEvents({
    int? countryId,
    bool? isOnline,
    bool? upcoming,
    int page = 1,
    int perPage = 15,
  }) async =>
      (null, null);

  @override
  Future<(Failure?, Event?)> getEventBySlug(String slug) async => (null, null);
}
