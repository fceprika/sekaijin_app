import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson creates valid UserModel with all fields', () {
      final json = {
        'id': 1,
        'name': 'testuser',
        'name_slug': 'testuser',
        'email': 'test@example.com',
        'email_verified_at': '2024-01-15T10:30:00.000Z',
        'first_name': 'John',
        'last_name': 'Doe',
        'birth_date': '1990-05-20',
        'phone': '+33612345678',
        'bio': 'A test bio',
        'avatar': 'avatars/user1.jpg',
        'country_residence': 'France',
        'city_residence': 'Paris',
        'interest_country': 'Japan',
        'latitude': 48.8566,
        'longitude': 2.3522,
        'is_visible_on_map': true,
        'country_id': 75,
        'youtube_username': 'johndoe',
        'instagram_username': 'johndoe',
        'tiktok_username': 'johndoe',
        'linkedin_username': 'johndoe',
        'twitter_username': 'johndoe',
        'facebook_username': 'johndoe',
        'telegram_username': 'johndoe',
        'role': 'premium',
        'is_verified': true,
        'is_public_profile': true,
        'last_login': '2024-01-20T15:00:00.000Z',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'testuser');
      expect(user.nameSlug, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.emailVerifiedAt, isNotNull);
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.birthDate, isNotNull);
      expect(user.phone, '+33612345678');
      expect(user.bio, 'A test bio');
      expect(user.avatar, 'avatars/user1.jpg');
      expect(user.countryResidence, 'France');
      expect(user.cityResidence, 'Paris');
      expect(user.interestCountry, 'Japan');
      expect(user.latitude, 48.8566);
      expect(user.longitude, 2.3522);
      expect(user.isVisibleOnMap, true);
      expect(user.countryId, 75);
      expect(user.youtubeUsername, 'johndoe');
      expect(user.instagramUsername, 'johndoe');
      expect(user.role, 'premium');
      expect(user.isVerified, true);
      expect(user.isPublicProfile, true);
      expect(user.lastLogin, isNotNull);
      expect(user.createdAt, isNotNull);
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'id': 1,
        'name': 'testuser',
        'name_slug': 'testuser',
        'email': 'test@example.com',
        'email_verified_at': null,
        'first_name': null,
        'last_name': null,
        'birth_date': null,
        'phone': null,
        'bio': null,
        'avatar': null,
        'country_residence': null,
        'city_residence': null,
        'interest_country': null,
        'latitude': null,
        'longitude': null,
        'is_visible_on_map': false,
        'country_id': null,
        'youtube_username': null,
        'instagram_username': null,
        'tiktok_username': null,
        'linkedin_username': null,
        'twitter_username': null,
        'facebook_username': null,
        'telegram_username': null,
        'role': 'free',
        'is_verified': false,
        'is_public_profile': false,
        'last_login': null,
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.emailVerifiedAt, isNull);
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
      expect(user.birthDate, isNull);
      expect(user.phone, isNull);
      expect(user.bio, isNull);
      expect(user.avatar, isNull);
      expect(user.latitude, isNull);
      expect(user.longitude, isNull);
      expect(user.isVisibleOnMap, false);
      expect(user.isVerified, false);
      expect(user.isPublicProfile, false);
      expect(user.lastLogin, isNull);
    });

    test('fromJson handles missing fields with defaults', () {
      final json = {
        'id': 1,
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 1);
      expect(user.name, '');
      expect(user.nameSlug, '');
      expect(user.email, '');
      expect(user.role, 'free');
      expect(user.isVisibleOnMap, false);
      expect(user.isVerified, false);
      expect(user.isPublicProfile, false);
    });

    test('toJson creates valid Map', () {
      final user = UserModel(
        id: 1,
        name: 'testuser',
        nameSlug: 'testuser',
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        role: 'premium',
        isVerified: true,
        isPublicProfile: true,
        isVisibleOnMap: true,
        createdAt: DateTime(2024, 1, 1),
      );

      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'testuser');
      expect(json['name_slug'], 'testuser');
      expect(json['email'], 'test@example.com');
      expect(json['first_name'], 'John');
      expect(json['last_name'], 'Doe');
      expect(json['role'], 'premium');
      expect(json['is_verified'], true);
      expect(json['is_public_profile'], true);
      expect(json['is_visible_on_map'], true);
      expect(json['created_at'], isNotNull);
    });

    test('displayName returns firstName when available', () {
      final user = UserModel(
        id: 1,
        name: 'testuser',
        nameSlug: 'testuser',
        email: 'test@example.com',
        firstName: 'John',
        createdAt: DateTime.now(),
      );

      expect(user.displayName, 'John');
    });

    test('displayName returns name when firstName is null', () {
      final user = UserModel(
        id: 1,
        name: 'testuser',
        nameSlug: 'testuser',
        email: 'test@example.com',
        createdAt: DateTime.now(),
      );

      expect(user.displayName, 'testuser');
    });

    test('fullAvatarUrl returns null when avatar is null', () {
      final user = UserModel(
        id: 1,
        name: 'testuser',
        nameSlug: 'testuser',
        email: 'test@example.com',
        createdAt: DateTime.now(),
      );

      expect(user.fullAvatarUrl, isNull);
    });

    test('fullAvatarUrl returns full URL for relative avatar path', () {
      final user = UserModel(
        id: 1,
        name: 'testuser',
        nameSlug: 'testuser',
        email: 'test@example.com',
        avatar: 'avatars/user1.jpg',
        createdAt: DateTime.now(),
      );

      expect(user.fullAvatarUrl, contains('storage/avatars/user1.jpg'));
    });

    test('fullAvatarUrl returns avatar unchanged when already absolute URL', () {
      final user = UserModel(
        id: 1,
        name: 'testuser',
        nameSlug: 'testuser',
        email: 'test@example.com',
        avatar: 'https://example.com/avatar.jpg',
        createdAt: DateTime.now(),
      );

      expect(user.fullAvatarUrl, 'https://example.com/avatar.jpg');
    });

    test('fromJson handles boolean as int (MySQL style)', () {
      final json = {
        'id': 1,
        'name': 'testuser',
        'name_slug': 'testuser',
        'email': 'test@example.com',
        'is_visible_on_map': 1,
        'is_verified': 1,
        'is_public_profile': 0,
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.isVisibleOnMap, true);
      expect(user.isVerified, true);
      expect(user.isPublicProfile, false);
    });

    test('fromJson handles latitude/longitude as strings', () {
      final json = {
        'id': 1,
        'name': 'testuser',
        'name_slug': 'testuser',
        'email': 'test@example.com',
        'latitude': '48.8566',
        'longitude': '2.3522',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.latitude, 48.8566);
      expect(user.longitude, 2.3522);
    });
  });
}
