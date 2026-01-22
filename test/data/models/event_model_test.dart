import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/data/models/event_model.dart';

void main() {
  group('EventModel', () {
    group('fromJson', () {
      test('parses basic event data correctly', () {
        final json = {
          'id': 1,
          'title': 'Test Event',
          'slug': 'test-event',
          'description': 'Test description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2025-01-25T18:00:00Z',
          'is_online': false,
          'price': 15.0,
          'current_participants': 8,
          'max_participants': 20,
          'created_at': '2025-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.id, 1);
        expect(event.title, 'Test Event');
        expect(event.slug, 'test-event');
        expect(event.description, 'Test description');
        expect(event.category, 'meetup');
        expect(event.countryId, 1);
        expect(event.organizerId, 1);
        expect(event.status, 'published');
        expect(event.isOnline, false);
        expect(event.price, 15.0);
        expect(event.currentParticipants, 8);
        expect(event.maxParticipants, 20);
      });

      test('parses dates correctly', () {
        final json = {
          'id': 1,
          'title': 'Test Event',
          'slug': 'test-event',
          'description': 'Test description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2025-01-25T18:00:00Z',
          'end_date': '2025-01-25T21:00:00Z',
          'created_at': '2025-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.startDate.year, 2025);
        expect(event.startDate.month, 1);
        expect(event.startDate.day, 25);
        expect(event.endDate, isNotNull);
        expect(event.endDate!.hour, 21);
      });

      test('handles missing optional fields', () {
        final json = {
          'id': 1,
          'title': 'Test Event',
          'slug': 'test-event',
          'description': 'Test description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2025-01-25T18:00:00Z',
          'created_at': '2025-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.fullDescription, isNull);
        expect(event.imageUrl, isNull);
        expect(event.endDate, isNull);
        expect(event.location, isNull);
        expect(event.address, isNull);
        expect(event.googleMapsUrl, isNull);
        expect(event.latitude, isNull);
        expect(event.longitude, isNull);
        expect(event.onlineLink, isNull);
        expect(event.maxParticipants, isNull);
      });

      test('parses online event correctly', () {
        final json = {
          'id': 2,
          'title': 'Online Event',
          'slug': 'online-event',
          'description': 'Online description',
          'category': 'webinar',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2025-02-01T14:00:00Z',
          'is_online': 1,
          'online_link': 'https://zoom.us/test',
          'price': 0,
          'current_participants': 15,
          'created_at': '2025-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.isOnline, true);
        expect(event.onlineLink, 'https://zoom.us/test');
        expect(event.price, 0);
      });

      test('parses organizer from user field', () {
        final json = {
          'id': 1,
          'title': 'Test Event',
          'slug': 'test-event',
          'description': 'Test description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2025-01-25T18:00:00Z',
          'created_at': '2025-01-01T10:00:00Z',
          'user': {
            'id': 1,
            'name': 'Test User',
            'name_slug': 'test-user',
            'email': 'test@example.com',
            'created_at': '2024-01-01T00:00:00Z',
          },
        };

        final event = EventModel.fromJson(json);

        expect(event.organizer, isNotNull);
        expect(event.organizer!.name, 'Test User');
      });
    });

    group('computed properties', () {
      test('isFree returns true when price is 0', () {
        final json = {
          'id': 1,
          'title': 'Free Event',
          'slug': 'free-event',
          'description': 'Free description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2025-01-25T18:00:00Z',
          'price': 0,
          'created_at': '2025-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.isFree, true);
      });

      test('isFree returns false when price is greater than 0', () {
        final json = {
          'id': 1,
          'title': 'Paid Event',
          'slug': 'paid-event',
          'description': 'Paid description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2025-01-25T18:00:00Z',
          'price': 25.0,
          'created_at': '2025-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.isFree, false);
      });

      test('isPast returns true when startDate is in the past', () {
        final json = {
          'id': 1,
          'title': 'Past Event',
          'slug': 'past-event',
          'description': 'Past description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2020-01-01T18:00:00Z',
          'created_at': '2020-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.isPast, true);
      });

      test('isPast returns false when startDate is in the future', () {
        final json = {
          'id': 1,
          'title': 'Future Event',
          'slug': 'future-event',
          'description': 'Future description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2030-01-25T18:00:00Z',
          'created_at': '2025-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.isPast, false);
      });

      test('isFull returns true when currentParticipants >= maxParticipants', () {
        final json = {
          'id': 1,
          'title': 'Full Event',
          'slug': 'full-event',
          'description': 'Full description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2030-01-25T18:00:00Z',
          'current_participants': 20,
          'max_participants': 20,
          'created_at': '2025-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.isFull, true);
      });

      test('isFull returns false when currentParticipants < maxParticipants', () {
        final json = {
          'id': 1,
          'title': 'Available Event',
          'slug': 'available-event',
          'description': 'Available description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2030-01-25T18:00:00Z',
          'current_participants': 10,
          'max_participants': 20,
          'created_at': '2025-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.isFull, false);
      });

      test('isFull returns false when maxParticipants is null', () {
        final json = {
          'id': 1,
          'title': 'Unlimited Event',
          'slug': 'unlimited-event',
          'description': 'Unlimited description',
          'category': 'meetup',
          'country_id': 1,
          'organizer_id': 1,
          'status': 'published',
          'start_date': '2030-01-25T18:00:00Z',
          'current_participants': 100,
          'created_at': '2025-01-01T10:00:00Z',
        };

        final event = EventModel.fromJson(json);

        expect(event.isFull, false);
      });
    });
  });
}
