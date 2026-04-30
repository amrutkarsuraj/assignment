import '../../../../core/network/api_client.dart';
import '../models/recipe_model.dart';

class RecipeRemoteDS {
  final ApiClient client;

  RecipeRemoteDS(this.client);

  Future<List<RecipeModel>> fetchRecipes(String category) async {
    final res = await client.get("filter.php", params: {"c": category});

    if (res.data['meals'] == null) return []; // 🔥 IMPORTANT

    return (res.data['meals'] as List)
        .map((e) => RecipeModel.fromJson(e))
        .toList();
  }

  Future<List<RecipeModel>> searchRecipes(String query) async {
    final res = await client.get("search.php", params: {"s": query});

    if (res.data['meals'] == null) return [];

    return (res.data['meals'] as List)
        .map((e) => RecipeModel.fromJson(e))
        .toList();
  }
}