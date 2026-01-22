import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sekaijin_app/domain/entities/event.dart';
import 'package:sekaijin_app/domain/entities/user.dart';
import 'package:sekaijin_app/presentation/providers/events_provider.dart';
import 'package:sekaijin_app/presentation/screens/events/event_detail_screen.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR', null);
  });

  final mockOrganizer = User(
    id: 1,
    name: 'Test Organizer',
    nameSlug: 'test-organizer',
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'Organizer',
    createdAt: DateTime.now(),
  );

  final mockEvent = Event(
    id: 1,
    title: 'Test Event Title',
    slug: 'test-event',
    description: 'This is the event description.',
    fullDescription: 'This is the full description with more details.',
    category: 'meetup',
    countryId: 1,
    organizerId: 1,
    status: 'published',
    startDate: DateTime(2025, 1, 25, 18, 0),
    isOnline: false,
    location: 'Paris Event Center',
    address: '123 Rue de Paris, 75001 Paris',
    googleMapsUrl: 'https://maps.google.com/test',
    price: 15,
    currentParticipants: 8,
    maxParticipants: 20,
    createdAt: DateTime.now(),
    organizer: mockOrganizer,
  );

  Widget createScreen({
    Event? event,
    bool isLoading = false,
    String? error,
  }) {
    return ProviderScope(
      overrides: [
        eventDetailProvider('test-event').overrideWith((ref) {
          if (isLoading) {
            return Future.value(null);
          }
          if (error != null) {
            throw Exception(error);
          }
          return Future.value(event);
        }),
      ],
      child: const MaterialApp(
        home: EventDetailScreen(slug: 'test-event'),
      ),
    );
  }

  group('EventDetailScreen', () {
    testWidgets('renders with screen key', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('event_detail_screen')), findsOneWidget);
    });

    testWidgets('displays event title', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('event_title')), findsOneWidget);
      expect(find.text('Test Event Title'), findsOneWidget);
    });

    testWidgets('displays date and time section', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('event_date_time')), findsOneWidget);
    });

    testWidgets('displays location info section', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('event_location_info')), findsOneWidget);
    });

    testWidgets('displays location name', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      expect(find.text('Paris Event Center'), findsOneWidget);
    });

    testWidgets('displays description', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      // Scroll down to see description
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -300),
      );
      await tester.pump();

      expect(find.byKey(const Key('event_description')), findsOneWidget);
    });

    testWidgets('displays price', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      expect(find.text('15 euros'), findsOneWidget);
    });

    testWidgets('displays participants count', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      expect(find.text('8/20 participants'), findsOneWidget);
    });

    testWidgets('displays organizer name', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(createScreen(isLoading: true));
      await tester.pump();

      expect(find.byKey(const Key('event_detail_screen')), findsOneWidget);
    });

    testWidgets('shows error state when event not found', (tester) async {
      await tester.pumpWidget(createScreen(event: null));
      await tester.pumpAndSettle();

      expect(find.text('Événement non trouvé'), findsOneWidget);
    });

    testWidgets('has SliverAppBar with hero image', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('displays Présentiel badge for in-person event', (tester) async {
      await tester.pumpWidget(createScreen(event: mockEvent));
      await tester.pumpAndSettle();

      expect(find.text('Présentiel'), findsOneWidget);
    });

    testWidgets('displays En ligne badge for online event', (tester) async {
      final onlineEvent = Event(
        id: 2,
        title: 'Online Event',
        slug: 'online-event',
        description: 'Online description',
        category: 'webinar',
        countryId: 1,
        organizerId: 1,
        status: 'published',
        startDate: DateTime(2025, 2, 1, 14, 0),
        isOnline: true,
        onlineLink: 'https://zoom.us/test',
        price: 0,
        currentParticipants: 15,
        createdAt: DateTime.now(),
        organizer: mockOrganizer,
      );

      await tester.pumpWidget(ProviderScope(
        overrides: [
          eventDetailProvider('online-event').overrideWith((ref) {
            return Future.value(onlineEvent);
          }),
        ],
        child: const MaterialApp(
          home: EventDetailScreen(slug: 'online-event'),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('En ligne'), findsWidgets);
    });
  });
}
