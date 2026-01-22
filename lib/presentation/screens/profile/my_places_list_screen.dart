import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/profile_provider.dart';
import '../../widgets/cards/compact_place_card.dart';

class MyPlacesListScreen extends ConsumerWidget {
  const MyPlacesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPlaces = ref.watch(myPlacesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      key: const Key('my_places_list_screen'),
      appBar: AppBar(
        title: const Text('Mes lieux'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myPlacesProvider);
        },
        child: myPlaces.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur: $error',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(myPlacesProvider),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
          data: (places) {
            if (places.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun lieu ajouté',
                      key: const Key('empty_places_message'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Commencez à partager vos bonnes adresses !',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/places/create'),
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter un lieu'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              key: const Key('places_list'),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return CompactPlaceCard(
                  place: place,
                  index: index,
                  onTap: () => context.push('/places/${place.slug}'),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add_place_fab'),
        onPressed: () => context.push('/places/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
