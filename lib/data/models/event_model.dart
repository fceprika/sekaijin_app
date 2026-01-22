import '../../domain/entities/country.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/user.dart';
import 'country_model.dart';
import 'user_model.dart';

class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.description,
    super.fullDescription,
    required super.category,
    super.imageUrl,
    required super.countryId,
    required super.organizerId,
    required super.status,
    super.isFeatured,
    required super.startDate,
    super.endDate,
    super.location,
    super.address,
    super.googleMapsUrl,
    super.latitude,
    super.longitude,
    super.isOnline,
    super.onlineLink,
    super.price,
    super.maxParticipants,
    super.currentParticipants,
    required super.createdAt,
    super.country,
    super.organizer,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    Country? country;
    if (json['country'] != null) {
      country = CountryModel.fromJson(json['country'] as Map<String, dynamic>);
    }

    User? organizer;
    if (json['organizer'] != null) {
      organizer = UserModel.fromJson(json['organizer'] as Map<String, dynamic>);
    } else if (json['user'] != null) {
      organizer = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    }

    return EventModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      fullDescription: json['full_description'] as String?,
      category: json['category'] as String? ?? 'meetup',
      imageUrl: json['image_url'] as String?,
      countryId: json['country_id'] as int? ?? 0,
      organizerId: json['organizer_id'] as int? ?? json['user_id'] as int? ?? 0,
      status: json['status'] as String? ?? 'draft',
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      startDate: _parseDateTime(json['start_date']) ?? DateTime.now(),
      endDate: _parseDateTime(json['end_date']),
      location: json['location'] as String?,
      address: json['address'] as String?,
      googleMapsUrl: json['google_maps_url'] as String?,
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      isOnline: json['is_online'] == true || json['is_online'] == 1,
      onlineLink: json['online_link'] as String?,
      price: _parseDouble(json['price']) ?? 0,
      maxParticipants: json['max_participants'] as int?,
      currentParticipants: json['current_participants'] as int? ?? 0,
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      country: country,
      organizer: organizer,
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
      'title': title,
      'slug': slug,
      'description': description,
      'full_description': fullDescription,
      'category': category,
      'image_url': imageUrl,
      'country_id': countryId,
      'organizer_id': organizerId,
      'status': status,
      'is_featured': isFeatured,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'location': location,
      'address': address,
      'google_maps_url': googleMapsUrl,
      'latitude': latitude,
      'longitude': longitude,
      'is_online': isOnline,
      'online_link': onlineLink,
      'price': price,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
