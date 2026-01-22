import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/theme.dart';

class ImagePickerField extends StatelessWidget {
  final List<File> images;
  final int maxImages;
  final ValueChanged<List<File>> onChanged;

  const ImagePickerField({
    super.key,
    required this.images,
    this.maxImages = 3,
    required this.onChanged,
  });

  Future<void> _pickImage(BuildContext context) async {
    if (images.length >= maxImages) return;

    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        key: const Key('image_source_dialog'),
        title: const Text('Choisir une source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galerie'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Appareil photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final newImages = [...images, File(pickedFile.path)];
      onChanged(newImages);
    }
  }

  void _removeImage(int index) {
    final newImages = List<File>.from(images)..removeAt(index);
    onChanged(newImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos (max $maxImages)',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(maxImages, (index) {
            if (index < images.length) {
              return _ImageSlot(
                key: Key('image_slot_$index'),
                image: images[index],
                onRemove: () => _removeImage(index),
              );
            } else if (index == images.length) {
              return _AddImageSlot(
                key: Key('add_image_slot_$index'),
                onTap: () => _pickImage(context),
              );
            } else {
              return _EmptyImageSlot(
                key: Key('empty_image_slot_$index'),
              );
            }
          }),
        ),
      ],
    );
  }
}

class _ImageSlot extends StatelessWidget {
  final File image;
  final VoidCallback onRemove;

  const _ImageSlot({
    super.key,
    required this.image,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddImageSlot extends StatelessWidget {
  final VoidCallback onTap;

  const _AddImageSlot({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: AspectRatio(
          aspectRatio: 1,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.add_photo_alternate,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyImageSlot extends StatelessWidget {
  const _EmptyImageSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.onBackground.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.onBackground.withValues(alpha: 0.1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
