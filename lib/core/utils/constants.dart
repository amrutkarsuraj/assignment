import 'package:hive/hive.dart';

import '../../features/recipe/data/models/recipe_model.dart';




Future<void> toggleFavorite(RecipeModel recipe) async {
  final box = Hive.box('favorites');

  if (box.containsKey(recipe.id)) {
    box.delete(recipe.id);
  } else {
    box.put(recipe.id, recipe.toJson());
  }
}