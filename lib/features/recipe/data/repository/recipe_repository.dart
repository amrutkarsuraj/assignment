import '../../data/models/recipe_model.dart';

abstract class RecipeRepository {
  Future<List<RecipeModel>> getRecipes(String category);
  Future<List<RecipeModel>> searchRecipes(String query);

  Future<void> toggleFavorite(RecipeModel recipe); // ✅ REQUIRED
  List<RecipeModel> getFavorites(); // ✅ REQUIRED
}