import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme.dart';
import '../../../domain/entities/place_review.dart';
import '../../providers/reviews_provider.dart';
import '../../widgets/dialogs/confirm_dialog.dart';
import '../../widgets/forms/star_rating_input.dart';

class ReviewFormScreen extends ConsumerStatefulWidget {
  final String placeSlug;
  final String placeName;
  final PlaceReview? existingReview;

  const ReviewFormScreen({
    super.key,
    required this.placeSlug,
    required this.placeName,
    this.existingReview,
  });

  @override
  ConsumerState<ReviewFormScreen> createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends ConsumerState<ReviewFormScreen> {
  late final TextEditingController _commentController;

  bool get isEditing => widget.existingReview != null;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(
      text: widget.existingReview?.comment ?? '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final notifier = ref.read(
      reviewFormProvider((
        placeSlug: widget.placeSlug,
        existingReview: widget.existingReview,
      )).notifier,
    );

    final success = await notifier.submit();

    if (success && mounted) {
      context.pop(true);
    }
  }

  Future<void> _delete() async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Supprimer l\'avis',
      message: 'Êtes-vous sûr de vouloir supprimer votre avis ? Cette action est irréversible.',
      confirmText: 'Supprimer',
      isDestructive: true,
    );

    if (confirmed != true) return;

    final notifier = ref.read(
      reviewFormProvider((
        placeSlug: widget.placeSlug,
        existingReview: widget.existingReview,
      )).notifier,
    );

    final success = await notifier.delete();

    if (success && mounted) {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(
      reviewFormProvider((
        placeSlug: widget.placeSlug,
        existingReview: widget.existingReview,
      )),
    );
    final notifier = ref.read(
      reviewFormProvider((
        placeSlug: widget.placeSlug,
        existingReview: widget.existingReview,
      )).notifier,
    );

    // Listen for errors
    ref.listen(
      reviewFormProvider((
        placeSlug: widget.placeSlug,
        existingReview: widget.existingReview,
      )),
      (previous, next) {
        if (next.error != null && previous?.error != next.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: AppColors.error,
            ),
          );
        }
        if (next.successMessage != null && previous?.successMessage != next.successMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.successMessage!),
              backgroundColor: AppColors.secondary,
            ),
          );
        }
      },
    );

    return Scaffold(
      key: const Key('review_form_screen'),
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier mon avis' : 'Donner mon avis'),
        centerTitle: true,
        actions: [
          if (isEditing)
            IconButton(
              key: const Key('delete_review_button'),
              onPressed: formState.isSubmitting ? null : _delete,
              icon: const Icon(Icons.delete_outline),
              color: AppColors.error,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place name
            Text(
              widget.placeName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            // Rating section
            Text(
              'Votre note',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Center(
              child: StarRatingInput(
                key: const Key('star_rating_input'),
                rating: formState.rating,
                onChanged: notifier.setRating,
                size: 48,
                enabled: !formState.isSubmitting,
              ),
            ),
            if (formState.rating == 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    'Appuyez sur une étoile pour noter',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onBackground.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Comment section
            Text(
              'Votre commentaire',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('review_comment_field'),
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Partagez votre expérience...',
                alignLabelWithHint: true,
                counterText: '${formState.comment.length} caractères',
              ),
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              enabled: !formState.isSubmitting,
              onChanged: notifier.setComment,
            ),
            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('submit_review_button'),
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
                    : Text(
                        isEditing ? 'Mettre à jour' : 'Publier mon avis',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Guidelines note
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
                      'Soyez respectueux et constructif dans vos commentaires.',
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
    );
  }
}
