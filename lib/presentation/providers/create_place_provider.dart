import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/create_place_request.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/place.dart';
import '../../services/image_compression_service.dart';
import 'places_provider.dart';

// Image compression service provider
final imageCompressionServiceProvider = Provider<ImageCompressionService>((ref) {
  return ImageCompressionService();
});

// Mock cities data - in production this would come from an API
final citiesProvider = Provider<List<City>>((ref) {
  return [
    const City(
      id: 1,
      name: 'Tokyo',
      slug: 'tokyo',
      countryId: 1,
      isMajor: true,
      order: 1,
      country: Country(
        id: 1,
        nameFr: 'Japon',
        slug: 'japon',
        emoji: '🇯🇵',
      ),
    ),
    const City(
      id: 2,
      name: 'Osaka',
      slug: 'osaka',
      countryId: 1,
      isMajor: true,
      order: 2,
      country: Country(
        id: 1,
        nameFr: 'Japon',
        slug: 'japon',
        emoji: '🇯🇵',
      ),
    ),
    const City(
      id: 3,
      name: 'Kyoto',
      slug: 'kyoto',
      countryId: 1,
      isMajor: true,
      order: 3,
      country: Country(
        id: 1,
        nameFr: 'Japon',
        slug: 'japon',
        emoji: '🇯🇵',
      ),
    ),
    const City(
      id: 4,
      name: 'Bangkok',
      slug: 'bangkok',
      countryId: 2,
      isMajor: true,
      order: 1,
      country: Country(
        id: 2,
        nameFr: 'Thaïlande',
        slug: 'thailande',
        emoji: '🇹🇭',
      ),
    ),
    const City(
      id: 5,
      name: 'Chiang Mai',
      slug: 'chiang-mai',
      countryId: 2,
      isMajor: true,
      order: 2,
      country: Country(
        id: 2,
        nameFr: 'Thaïlande',
        slug: 'thailande',
        emoji: '🇹🇭',
      ),
    ),
    const City(
      id: 6,
      name: 'Bali',
      slug: 'bali',
      countryId: 3,
      isMajor: true,
      order: 1,
      country: Country(
        id: 3,
        nameFr: 'Indonésie',
        slug: 'indonesie',
        emoji: '🇮🇩',
      ),
    ),
  ];
});

// Create place form state
class CreatePlaceFormState {
  final String title;
  final int? cityId;
  final PlaceCategory? category;
  final String description;
  final String googleMapsUrl;
  final String? address;
  final String? menuUrl;
  final String? websiteUrl;
  final String? youtubeUrl;
  final int? wifiSpeed;
  final List<File> images;
  final bool isSubmitting;
  final String? error;
  final String? successMessage;

  const CreatePlaceFormState({
    this.title = '',
    this.cityId,
    this.category,
    this.description = '',
    this.googleMapsUrl = '',
    this.address,
    this.menuUrl,
    this.websiteUrl,
    this.youtubeUrl,
    this.wifiSpeed,
    this.images = const [],
    this.isSubmitting = false,
    this.error,
    this.successMessage,
  });

  CreatePlaceFormState copyWith({
    String? title,
    int? cityId,
    PlaceCategory? category,
    String? description,
    String? googleMapsUrl,
    String? address,
    String? menuUrl,
    String? websiteUrl,
    String? youtubeUrl,
    int? wifiSpeed,
    List<File>? images,
    bool? isSubmitting,
    String? error,
    String? successMessage,
    bool clearCityId = false,
    bool clearCategory = false,
    bool clearAddress = false,
    bool clearMenuUrl = false,
    bool clearWebsiteUrl = false,
    bool clearYoutubeUrl = false,
    bool clearWifiSpeed = false,
    bool clearError = false,
    bool clearSuccessMessage = false,
  }) {
    return CreatePlaceFormState(
      title: title ?? this.title,
      cityId: clearCityId ? null : (cityId ?? this.cityId),
      category: clearCategory ? null : (category ?? this.category),
      description: description ?? this.description,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
      address: clearAddress ? null : (address ?? this.address),
      menuUrl: clearMenuUrl ? null : (menuUrl ?? this.menuUrl),
      websiteUrl: clearWebsiteUrl ? null : (websiteUrl ?? this.websiteUrl),
      youtubeUrl: clearYoutubeUrl ? null : (youtubeUrl ?? this.youtubeUrl),
      wifiSpeed: clearWifiSpeed ? null : (wifiSpeed ?? this.wifiSpeed),
      images: images ?? this.images,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }

  bool get isValid {
    if (title.trim().isEmpty) return false;
    if (cityId == null) return false;
    if (category == null) return false;
    if (description.trim().length < 10) return false;
    if (googleMapsUrl.trim().isEmpty) return false;
    return true;
  }
}

// Create place form notifier
class CreatePlaceFormNotifier extends StateNotifier<CreatePlaceFormState> {
  final Ref _ref;

  CreatePlaceFormNotifier(this._ref) : super(const CreatePlaceFormState());

  void setTitle(String value) {
    state = state.copyWith(title: value, clearError: true);
  }

  void setCityId(int? value) {
    if (value == null) {
      state = state.copyWith(clearCityId: true, clearError: true);
    } else {
      state = state.copyWith(cityId: value, clearError: true);
    }
  }

  void setCategory(PlaceCategory? value) {
    if (value == null) {
      state = state.copyWith(clearCategory: true, clearError: true);
    } else {
      state = state.copyWith(category: value, clearError: true);
      // Clear wifi speed if not workspace category
      if (value != PlaceCategory.espacesTravail) {
        state = state.copyWith(clearWifiSpeed: true);
      }
    }
  }

  void setDescription(String value) {
    state = state.copyWith(description: value, clearError: true);
  }

  void setGoogleMapsUrl(String value) {
    state = state.copyWith(googleMapsUrl: value, clearError: true);
  }

  void setAddress(String? value) {
    if (value == null || value.isEmpty) {
      state = state.copyWith(clearAddress: true, clearError: true);
    } else {
      state = state.copyWith(address: value, clearError: true);
    }
  }

  void setMenuUrl(String? value) {
    if (value == null || value.isEmpty) {
      state = state.copyWith(clearMenuUrl: true, clearError: true);
    } else {
      state = state.copyWith(menuUrl: value, clearError: true);
    }
  }

  void setWebsiteUrl(String? value) {
    if (value == null || value.isEmpty) {
      state = state.copyWith(clearWebsiteUrl: true, clearError: true);
    } else {
      state = state.copyWith(websiteUrl: value, clearError: true);
    }
  }

  void setYoutubeUrl(String? value) {
    if (value == null || value.isEmpty) {
      state = state.copyWith(clearYoutubeUrl: true, clearError: true);
    } else {
      state = state.copyWith(youtubeUrl: value, clearError: true);
    }
  }

  void setWifiSpeed(int? value) {
    if (value == null) {
      state = state.copyWith(clearWifiSpeed: true, clearError: true);
    } else {
      state = state.copyWith(wifiSpeed: value, clearError: true);
    }
  }

  void setImages(List<File> value) {
    state = state.copyWith(images: value, clearError: true);
  }

  void addImage(File image) {
    if (state.images.length < 3) {
      state = state.copyWith(images: [...state.images, image], clearError: true);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < state.images.length) {
      final newImages = List<File>.from(state.images)..removeAt(index);
      state = state.copyWith(images: newImages, clearError: true);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearSuccessMessage() {
    state = state.copyWith(clearSuccessMessage: true);
  }

  void reset() {
    state = const CreatePlaceFormState();
  }

  Future<bool> submit() async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      // Compress images
      final compressionService = _ref.read(imageCompressionServiceProvider);
      final compressedImages = await compressionService.compressImages(state.images);

      // Create request
      final request = CreatePlaceRequest(
        title: state.title.trim(),
        cityId: state.cityId!,
        category: state.category!.slug,
        description: state.description.trim(),
        googleMapsUrl: state.googleMapsUrl.trim(),
        address: state.address?.trim(),
        menuUrl: state.menuUrl?.trim(),
        websiteUrl: state.websiteUrl?.trim(),
        youtubeUrl: state.youtubeUrl?.trim(),
        wifiSpeed: state.wifiSpeed,
        images: compressedImages,
      );

      // Submit
      final repository = _ref.read(placeRepositoryProvider);
      final (failure, _) = await repository.createPlace(request);

      if (failure != null) {
        state = state.copyWith(
          isSubmitting: false,
          error: failure.message,
        );
        return false;
      }

      state = state.copyWith(
        isSubmitting: false,
        successMessage: 'Lieu créé avec succès. Il sera visible après validation.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Une erreur inattendue est survenue',
      );
      return false;
    }
  }
}

// Create place form provider
final createPlaceFormProvider =
    StateNotifierProvider<CreatePlaceFormNotifier, CreatePlaceFormState>((ref) {
  return CreatePlaceFormNotifier(ref);
});
