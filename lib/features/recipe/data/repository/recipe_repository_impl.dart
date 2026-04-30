import 'package:assignment/features/recipe/data/repository/recipe_repository.dart';

import '../../../../core/network/network_info.dart';
import '../datasource/recipe_local_ds.dart';
import '../datasource/recipe_remote_ds.dart';
import '../models/recipe_model.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDS remote;
  final RecipeLocalDS local;
  final NetworkInfo network;

  RecipeRepositoryImpl(this.remote, this.local, this.network);

  @override
  Future<List<RecipeModel>> getRecipes(String category) async {
    final isConnected = await network.isConnected;

    try {
      if (isConnected) {
        final data = await remote.fetchRecipes(category);

        if (data.isNotEmpty) {
          await local.cacheRecipes(data);
          return data;
        }
      }
    } catch (e) {

    }

    final cached = local.getCachedRecipes();
    if (cached.isNotEmpty) return cached;

    final favorites = local.getFavorites();
    if (favorites.isNotEmpty) return favorites;

    return [];
  }

  @override
  Future<List<RecipeModel>> searchRecipes(String query) async {
    return await remote.searchRecipes(query);
  }

  @override
  Future<void> toggleFavorite(RecipeModel recipe) async {
    await local.toggleFavorite(recipe);
  }

  @override
  List<RecipeModel> getFavorites() {
    return local.getFavorites();
  }
}