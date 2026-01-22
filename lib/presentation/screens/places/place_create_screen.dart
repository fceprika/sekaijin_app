import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/city.dart';
import '../../../domain/entities/place.dart';
import '../../providers/create_place_provider.dart';
import '../../widgets/forms/image_picker_field.dart';

class PlaceCreateScreen extends ConsumerStatefulWidget {
  const PlaceCreateScreen({super.key});

  @override
  ConsumerState<PlaceCreateScreen> createState() => _PlaceCreateScreenState();
}

class _PlaceCreateScreenState extends ConsumerState<PlaceCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _googleMapsController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _menuController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _wifiSpeedController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _googleMapsController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _menuController.dispose();
    _youtubeController.dispose();
    _wifiSpeedController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(createPlaceFormProvider.notifier).submit();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lieu créé avec succès. Il sera visible après validation.'),
          backgroundColor: AppColors.secondary,
        ),
      );
      ref.read(createPlaceFormProvider.notifier).reset();
      _resetForm();
      context.go('/explore');
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _googleMapsController.clear();
    _addressController.clear();
    _websiteController.clear();
    _menuController.clear();
    _youtubeController.clear();
    _wifiSpeedController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createPlaceFormProvider);
    final cities = ref.watch(citiesProvider);
    final notifier = ref.read(createPlaceFormProvider.notifier);

    // Show error if any
    ref.listen<CreatePlaceFormState>(createPlaceFormProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      key: const Key('place_create_screen'),
      appBar: AppBar(
        title: const Text('Ajouter un lieu'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image picker
              ImagePickerField(
                key: const Key('place_images_picker'),
                images: formState.images,
                maxImages: 3,
                onChanged: (images) => notifier.setImages(images),
              ),
              const SizedBox(height: 24),

              // Title field
              TextFormField(
                key: const Key('place_title_field'),
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nom du lieu *',
                  hintText: 'Ex: Cafe Nomad',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) => Validators.required(value, fieldName: 'Le nom'),
                onChanged: notifier.setTitle,
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<PlaceCategory>(
                key: const Key('place_category_dropdown'),
                initialValue: formState.category,
                decoration: const InputDecoration(
                  labelText: 'Catégorie *',
                ),
                items: PlaceCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text('${category.emoji} ${category.label}'),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Veuillez sélectionner une catégorie' : null,
                onChanged: notifier.setCategory,
              ),
              const SizedBox(height: 16),

              // City dropdown
              _CityDropdown(
                key: const Key('place_city_dropdown'),
                cities: cities,
                value: formState.cityId,
                onChanged: notifier.setCityId,
              ),
              const SizedBox(height: 16),

              // Google Maps URL
              TextFormField(
                key: const Key('place_google_maps_field'),
                controller: _googleMapsController,
                decoration: const InputDecoration(
                  labelText: 'Lien Google Maps *',
                  hintText: 'https://maps.google.com/...',
                  helperText: 'Copiez le lien depuis Google Maps > Partager',
                  helperMaxLines: 2,
                ),
                keyboardType: TextInputType.url,
                validator: Validators.googleMapsUrl,
                onChanged: notifier.setGoogleMapsUrl,
              ),
              const SizedBox(height: 16),

              // Address field
              TextFormField(
                key: const Key('place_address_field'),
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Adresse',
                  hintText: 'Ex: 123 Rue Example',
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) => notifier.setAddress(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 16),

              // Description field
              TextFormField(
                key: const Key('place_description_field'),
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Décrivez ce lieu...',
                  alignLabelWithHint: true,
                  counterText: '${formState.description.length} caractères',
                ),
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                validator: Validators.description,
                onChanged: notifier.setDescription,
              ),
              const SizedBox(height: 24),

              // Optional fields header
              Text(
                'Informations optionnelles',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
              ),
              const SizedBox(height: 16),

              // Website URL
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Site web',
                  hintText: 'https://...',
                  prefixIcon: Icon(Icons.language),
                ),
                keyboardType: TextInputType.url,
                validator: (value) => Validators.url(value, fieldName: 'URL du site web'),
                onChanged: (value) => notifier.setWebsiteUrl(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 16),

              // Menu URL (show for restaurants and workspaces)
              if (formState.category == PlaceCategory.restaurants ||
                  formState.category == PlaceCategory.espacesTravail) ...[
                TextFormField(
                  controller: _menuController,
                  decoration: const InputDecoration(
                    labelText: 'Lien du menu',
                    hintText: 'https://...',
                    prefixIcon: Icon(Icons.restaurant_menu),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) => Validators.url(value, fieldName: 'URL du menu'),
                  onChanged: (value) => notifier.setMenuUrl(value.isEmpty ? null : value),
                ),
                const SizedBox(height: 16),
              ],

              // YouTube URL
              TextFormField(
                controller: _youtubeController,
                decoration: const InputDecoration(
                  labelText: 'Vidéo YouTube',
                  hintText: 'https://youtube.com/...',
                  prefixIcon: Icon(Icons.play_circle_outline),
                ),
                keyboardType: TextInputType.url,
                validator: (value) => Validators.url(value, fieldName: 'URL YouTube'),
                onChanged: (value) => notifier.setYoutubeUrl(value.isEmpty ? null : value),
              ),
              const SizedBox(height: 16),

              // Wifi speed (only for workspaces)
              if (formState.category == PlaceCategory.espacesTravail) ...[
                TextFormField(
                  controller: _wifiSpeedController,
                  decoration: const InputDecoration(
                    labelText: 'Vitesse Wifi (Mbps)',
                    hintText: 'Ex: 100',
                    prefixIcon: Icon(Icons.wifi),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => Validators.positiveNumber(value, fieldName: 'La vitesse Wifi'),
                  onChanged: (value) {
                    final speed = int.tryParse(value);
                    notifier.setWifiSpeed(speed);
                  },
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const Key('submit_place_button'),
                  onPressed: formState.isSubmitting || !formState.isValid ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                  ),
                  child: formState.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Ajouter le lieu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Info note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Votre lieu sera vérifié par un modérateur avant d\'être publié.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onBackground.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityDropdown extends StatefulWidget {
  final List<City> cities;
  final int? value;
  final ValueChanged<int?> onChanged;

  const _CityDropdown({
    super.key,
    required this.cities,
    this.value,
    required this.onChanged,
  });

  @override
  State<_CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<_CityDropdown> {
  String _searchQuery = '';

  List<City> get _filteredCities {
    if (_searchQuery.isEmpty) return widget.cities;
    return widget.cities.where((city) {
      final searchLower = _searchQuery.toLowerCase();
      return city.name.toLowerCase().contains(searchLower) ||
          (city.country?.nameFr.toLowerCase().contains(searchLower) ?? false);
    }).toList();
  }

  Map<String, List<City>> get _groupedCities {
    final grouped = <String, List<City>>{};
    for (final city in _filteredCities) {
      final countryName = city.country?.nameFr ?? 'Autre';
      if (!grouped.containsKey(countryName)) {
        grouped[countryName] = [];
      }
      grouped[countryName]!.add(city);
    }
    return grouped;
  }

  City? get _selectedCity {
    if (widget.value == null) return null;
    try {
      return widget.cities.firstWhere((city) => city.id == widget.value);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<int>(
      initialValue: widget.value,
      validator: (value) => value == null ? 'Veuillez sélectionner une ville' : null,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _showCityPicker(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Ville *',
                  errorText: field.errorText,
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
                child: Text(
                  _selectedCity != null
                      ? '${_selectedCity!.country?.emoji ?? ''} ${_selectedCity!.name}'
                      : 'Sélectionner une ville',
                  style: TextStyle(
                    color: _selectedCity != null
                        ? AppColors.onBackground
                        : AppColors.onBackground.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCityPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.onBackground.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Rechercher une ville...',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setSheetState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: _groupedCities.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              ...entry.value.map((city) {
                                final isSelected = city.id == widget.value;
                                return ListTile(
                                  leading: Text(
                                    city.country?.emoji ?? '',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  title: Text(city.name),
                                  trailing: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          color: AppColors.primary,
                                        )
                                      : null,
                                  selected: isSelected,
                                  onTap: () {
                                    widget.onChanged(city.id);
                                    Navigator.pop(context);
                                  },
                                );
                              }),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
