import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String nameSlug;
  final String email;
  final DateTime? emailVerifiedAt;
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;
  final String? phone;
  final String? bio;
  final String? avatar;
  final String? countryResidence;
  final String? cityResidence;
  final String? interestCountry;
  final double? latitude;
  final double? longitude;
  final bool isVisibleOnMap;
  final int? countryId;
  final String? youtubeUsername;
  final String? instagramUsername;
  final String? tiktokUsername;
  final String? linkedinUsername;
  final String? twitterUsername;
  final String? facebookUsername;
  final String? telegramUsername;
  final String role;
  final bool isVerified;
  final bool isPublicProfile;
  final DateTime? lastLogin;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.nameSlug,
    required this.email,
    this.emailVerifiedAt,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.phone,
    this.bio,
    this.avatar,
    this.countryResidence,
    this.cityResidence,
    this.interestCountry,
    this.latitude,
    this.longitude,
    this.isVisibleOnMap = false,
    this.countryId,
    this.youtubeUsername,
    this.instagramUsername,
    this.tiktokUsername,
    this.linkedinUsername,
    this.twitterUsername,
    this.facebookUsername,
    this.telegramUsername,
    this.role = 'free',
    this.isVerified = false,
    this.isPublicProfile = false,
    this.lastLogin,
    required this.createdAt,
  });

  String get displayName => firstName ?? name;

  String? get fullAvatarUrl {
    if (avatar == null) return null;
    if (avatar!.startsWith('http')) return avatar;
    final baseUrl = AppConfig.baseUrl.replaceAll('/api', '');
    return '$baseUrl/storage/$avatar';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameSlug,
        email,
        emailVerifiedAt,
        firstName,
        lastName,
        birthDate,
        phone,
        bio,
        avatar,
        countryResidence,
        cityResidence,
        interestCountry,
        latitude,
        longitude,
        isVisibleOnMap,
        countryId,
        youtubeUsername,
        instagramUsername,
        tiktokUsername,
        linkedinUsername,
        twitterUsername,
        facebookUsername,
        telegramUsername,
        role,
        isVerified,
        isPublicProfile,
        lastLogin,
        createdAt,
      ];
}
