import 'package:hive/hive.dart';
import '../models/recipe_model.dart';

class RecipeLocalDS {
  final Box box;

  RecipeLocalDS(this.box);

  Future<void> cacheRecipes(List<RecipeModel> recipes) async {
    final list = recipes.map((e) => e.toJson()).toList();
    await box.put("recipes", list);
  }

  List<RecipeModel> getCachedRecipes() {
    final data = box.get("recipes");

    if (data == null) return [];

    return (data as List)
        .map((e) => RecipeModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
  
  Future<void> toggleFavorite(RecipeModel recipe) async {
    final favBox = Hive.box('favorites');

    if (favBox.containsKey(recipe.id)) {
      favBox.delete(recipe.id);
    } else {
      favBox.put(recipe.id, recipe.toJson());
    }
  }

  List<RecipeModel> getFavorites() {
    final favBox = Hive.box('favorites');

    return favBox.values
        .map((e) => RecipeModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}