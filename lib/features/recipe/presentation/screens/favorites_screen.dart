import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';


class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recipeProvider.notifier);
    final favorites = notifier.getFavorites();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites ❤️")),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet ❤️"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: favorites.length,
        itemBuilder: (_, i) {
          final recipe = favorites[i];

          return RecipeCard(
            recipe: recipe,
            isFav: true,
            onFavTap: () => notifier.toggleFavorite(recipe),
            onTap: () {},
          );
        },
      ),
    );
  }
}