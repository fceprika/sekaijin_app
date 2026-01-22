import 'dart:io';

import 'package:dio/dio.dart';

class CreatePlaceRequest {
  final String title;
  final int cityId;
  final String category;
  final String description;
  final String googleMapsUrl;
  final String? address;
  final String? menuUrl;
  final String? websiteUrl;
  final String? youtubeUrl;
  final int? wifiSpeed;
  final List<File> images;

  CreatePlaceRequest({
    required this.title,
    required this.cityId,
    required this.category,
    required this.description,
    required this.googleMapsUrl,
    this.address,
    this.menuUrl,
    this.websiteUrl,
    this.youtubeUrl,
    this.wifiSpeed,
    this.images = const [],
  });

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap({
      'title': title,
      'city_id': cityId,
      'category': category,
      'description': description,
      'google_maps_url': googleMapsUrl,
      if (address != null && address!.isNotEmpty) 'address': address,
      if (menuUrl != null && menuUrl!.isNotEmpty) 'menu_url': menuUrl,
      if (websiteUrl != null && websiteUrl!.isNotEmpty) 'website_url': websiteUrl,
      if (youtubeUrl != null && youtubeUrl!.isNotEmpty) 'youtube_url': youtubeUrl,
      if (wifiSpeed != null) 'wifi_speed': wifiSpeed,
    });

    for (int i = 0; i < images.length; i++) {
      final file = images[i];
      final fileName = file.path.split('/').last;
      formData.files.add(MapEntry(
        'images[]',
        await MultipartFile.fromFile(file.path, filename: fileName),
      ));
    }

    return formData;
  }
}
