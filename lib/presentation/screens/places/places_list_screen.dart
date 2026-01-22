import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/places_provider.dart';
import '../../widgets/cards/place_list_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_state.dart';
import '../../widgets/common/loading_shimmer.dart';
import '../../widgets/filters/category_chips.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  const PlacesListScreen({super.key});

  @override
  ConsumerState<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(placesProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final placesState = ref.watch(placesProvider);
    final sortBy = ref.watch(placeSortProvider);

    return Scaffold(
      key: const Key('places_list_screen'),
      appBar: AppBar(
        title: const Text('Explorer'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(placesProvider.notifier).refresh();
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Category filter chips
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: CategoryChips(),
              ),
            ),

            // Filters row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Sort dropdown
                    Expanded(
                      child: _SortDropdown(
                        key: const Key('sort_dropdown'),
                        value: sortBy,
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(placeSortProvider.notifier).state = value;
                            if (value == 'rating_average') {
                              ref.read(placeSortOrderProvider.notifier).state = 'desc';
                            } else {
                              ref.read(placeSortOrderProvider.notifier).state = 'desc';
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Results count
            if (!placesState.isLoading || placesState.places.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${placesState.total} lieux trouvés',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onBackground.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),

            // Content
            if (placesState.isLoading && placesState.places.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const PlaceCardShimmer(),
                    childCount: 3,
                  ),
                ),
              )
            else if (placesState.error != null && placesState.places.isEmpty)
              SliverFillRemaining(
                child: ErrorState(
                  message: placesState.error!,
                  onRetry: () => ref.read(placesProvider.notifier).refresh(),
                ),
              )
            else if (placesState.places.isEmpty)
              SliverFillRemaining(
                child: EmptyState.noPlaces(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                sliver: SliverList(
                  key: const Key('places_list'),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == placesState.places.length) {
                        if (placesState.isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }

                      final place = placesState.places[index];
                      return PlaceListCard(
                        key: Key('place_card_$index'),
                        place: place,
                        onTap: () {
                          context.push('/places/${place.slug}');
                        },
                      );
                    },
                    childCount: placesState.places.length +
                        (placesState.hasMore ? 1 : 0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _SortDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.onBackground.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: const [
            DropdownMenuItem(
              value: 'created_at',
              child: Text('Plus récents'),
            ),
            DropdownMenuItem(
              value: 'rating_average',
              child: Text('Mieux notés'),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
