import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../core/config/app_config.dart';
import 'country.dart';
import 'user.dart';

class Event extends Equatable {
  final int id;
  final String title;
  final String slug;
  final String description;
  final String? fullDescription;
  final String category;
  final String? imageUrl;
  final int countryId;
  final int organizerId;
  final String status;
  final bool isFeatured;
  final DateTime startDate;
  final DateTime? endDate;
  final String? location;
  final String? address;
  final String? googleMapsUrl;
  final double? latitude;
  final double? longitude;
  final bool isOnline;
  final String? onlineLink;
  final double price;
  final int? maxParticipants;
  final int currentParticipants;
  final DateTime createdAt;
  final Country? country;
  final User? organizer;

  const Event({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    this.fullDescription,
    required this.category,
    this.imageUrl,
    required this.countryId,
    required this.organizerId,
    required this.status,
    this.isFeatured = false,
    required this.startDate,
    this.endDate,
    this.location,
    this.address,
    this.googleMapsUrl,
    this.latitude,
    this.longitude,
    this.isOnline = false,
    this.onlineLink,
    this.price = 0,
    this.maxParticipants,
    this.currentParticipants = 0,
    required this.createdAt,
    this.country,
    this.organizer,
  });

  bool get isFree => price == 0;

  bool get isPast => startDate.isBefore(DateTime.now());

  bool get isFull =>
      maxParticipants != null && currentParticipants >= maxParticipants!;

  String get formattedDate {
    final dayOfWeek = DateFormat('EEE', 'fr_FR').format(startDate);
    final day = startDate.day;
    final month = DateFormat('MMM', 'fr_FR').format(startDate);
    final year = startDate.year;
    final hour = DateFormat('HH', 'fr_FR').format(startDate);
    final minute = DateFormat('mm', 'fr_FR').format(startDate);

    return '${dayOfWeek.capitalize()} $day ${month.capitalize()} $year - ${hour}h$minute';
  }

  String? get fullImageUrl {
    if (imageUrl == null) return null;
    if (imageUrl!.startsWith('http')) return imageUrl;
    final baseUrl = AppConfig.baseUrl.replaceAll('/api', '');
    return '$baseUrl/storage/$imageUrl';
  }

  @override
  List<Object?> get props => [id, slug];
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
