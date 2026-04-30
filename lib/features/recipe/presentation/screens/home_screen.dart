import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/debounce.dart';
import '../providers/recipe_provider.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/favorite_icon.dart';
import 'detail_screen.dart';

import 'package:cached_network_image/cached_network_image.dart';


import 'favorites_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(recipeProvider.notifier).loadRecipes());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeProvider);
    final notifier = ref.read(recipeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Recipes 🍲"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Suggestions based on your time & location",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search recipes...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                debouncer(() {
                  notifier.search(value);
                });
              },
            ),
          ),

          Expanded(
            child: state.when(
              loading: () => const ShimmerLoader(),

              error: (e, _) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: ${e.toString()}"),
                    ),
                  );
                });

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60),
                      const SizedBox(height: 10),
                      const Text("Something went wrong"),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(recipeProvider.notifier).loadRecipes();
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              },

              data: (recipes) {
                if (recipes.isEmpty) {
                  return const Center(
                    child: Text("No recipes found / Offline mode 😔"),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await notifier.loadRecipes();
                  },

                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: recipes.length,
                    itemBuilder: (_, i) {
                      final recipe = recipes[i];

                      final favorites = notifier.getFavorites();
                      final isFav = favorites.any((e) => e.id == recipe.id);

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),

                          leading: Hero(
                            tag: recipe.id,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: recipe.image,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: const CircularProgressIndicator(),
                                ),
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),

                          title: Text(
                            recipe.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          trailing: FavoriteIcon(
                            isFav: isFav,
                            onTap: () {
                              notifier.toggleFavorite(recipe);
                            },
                          ),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(recipe: recipe),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
