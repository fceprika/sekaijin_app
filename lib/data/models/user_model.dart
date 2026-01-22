import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.nameSlug,
    required super.email,
    super.emailVerifiedAt,
    super.firstName,
    super.lastName,
    super.birthDate,
    super.phone,
    super.bio,
    super.avatar,
    super.countryResidence,
    super.cityResidence,
    super.interestCountry,
    super.latitude,
    super.longitude,
    super.isVisibleOnMap,
    super.countryId,
    super.youtubeUsername,
    super.instagramUsername,
    super.tiktokUsername,
    super.linkedinUsername,
    super.twitterUsername,
    super.facebookUsername,
    super.telegramUsername,
    super.role,
    super.isVerified,
    super.isPublicProfile,
    super.lastLogin,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameSlug: json['name_slug'] as String? ?? '',
      email: json['email'] as String? ?? '',
      emailVerifiedAt: _parseDateTime(json['email_verified_at']),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      birthDate: _parseDateTime(json['birth_date']),
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
      avatar: json['avatar'] as String?,
      countryResidence: json['country_residence'] as String?,
      cityResidence: json['city_residence'] as String?,
      interestCountry: json['interest_country'] as String?,
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      isVisibleOnMap: json['is_visible_on_map'] == true || json['is_visible_on_map'] == 1,
      countryId: json['country_id'] as int?,
      youtubeUsername: json['youtube_username'] as String?,
      instagramUsername: json['instagram_username'] as String?,
      tiktokUsername: json['tiktok_username'] as String?,
      linkedinUsername: json['linkedin_username'] as String?,
      twitterUsername: json['twitter_username'] as String?,
      facebookUsername: json['facebook_username'] as String?,
      telegramUsername: json['telegram_username'] as String?,
      role: json['role'] as String? ?? 'free',
      isVerified: json['is_verified'] == true || json['is_verified'] == 1,
      isPublicProfile: json['is_public_profile'] == true || json['is_public_profile'] == 1,
      lastLogin: _parseDateTime(json['last_login']),
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_slug': nameSlug,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate?.toIso8601String(),
      'phone': phone,
      'bio': bio,
      'avatar': avatar,
      'country_residence': countryResidence,
      'city_residence': cityResidence,
      'interest_country': interestCountry,
      'latitude': latitude,
      'longitude': longitude,
      'is_visible_on_map': isVisibleOnMap,
      'country_id': countryId,
      'youtube_username': youtubeUsername,
      'instagram_username': instagramUsername,
      'tiktok_username': tiktokUsername,
      'linkedin_username': linkedinUsername,
      'twitter_username': twitterUsername,
      'facebook_username': facebookUsername,
      'telegram_username': telegramUsername,
      'role': role,
      'is_verified': isVerified,
      'is_public_profile': isPublicProfile,
      'last_login': lastLogin?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      nameSlug: user.nameSlug,
      email: user.email,
      emailVerifiedAt: user.emailVerifiedAt,
      firstName: user.firstName,
      lastName: user.lastName,
      birthDate: user.birthDate,
      phone: user.phone,
      bio: user.bio,
      avatar: user.avatar,
      countryResidence: user.countryResidence,
      cityResidence: user.cityResidence,
      interestCountry: user.interestCountry,
      latitude: user.latitude,
      longitude: user.longitude,
      isVisibleOnMap: user.isVisibleOnMap,
      countryId: user.countryId,
      youtubeUsername: user.youtubeUsername,
      instagramUsername: user.instagramUsername,
      tiktokUsername: user.tiktokUsername,
      linkedinUsername: user.linkedinUsername,
      twitterUsername: user.twitterUsername,
      facebookUsername: user.facebookUsername,
      telegramUsername: user.telegramUsername,
      role: user.role,
      isVerified: user.isVerified,
      isPublicProfile: user.isPublicProfile,
      lastLogin: user.lastLogin,
      createdAt: user.createdAt,
    );
  }
}
