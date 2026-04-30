import 'package:assignment/features/recipe/presentation/providers/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/utils/time_utils.dart';
import '../../data/models/recipe_model.dart';


final recipeProvider =
StateNotifierProvider<RecipeNotifier, AsyncValue<List<RecipeModel>>>(
      (ref) => RecipeNotifier(ref),
);

final locationServiceProvider = Provider((ref) => LocationService());

class RecipeNotifier extends StateNotifier<AsyncValue<List<RecipeModel>>> {
  final Ref ref;

  RecipeNotifier(this.ref) : super(const AsyncLoading());

  /// 🔥 LOAD RECIPES (TIME + LOCATION BASED)
  Future<void> loadRecipes() async {
    try {
      final repo = ref.read(repositoryProvider);
      final locationService = ref.read(locationServiceProvider);

      final country = await locationService.getCountry();
      final mealType = getMealType();
      final category = _resolveCategory(mealType, country);

      final data = await repo.getRecipes(category);

      /// 🔥 NEVER THROW ERROR IF DATA EXISTS
      state = AsyncData(data);
    } catch (e) {
      /// fallback instead of error
      final fallback = ref.read(repositoryProvider).getFavorites();

      if (fallback.isNotEmpty) {
        state = AsyncData(fallback);
      } else {
        state = AsyncError(e, StackTrace.current);
      }
    }
  }

  /// 🔥 CORE LOGIC (INTERVIEW IMPORTANT)
  String _resolveCategory(String mealType, String country) {
    // Location priority first
    switch (country) {
      case "India":
        return "Vegetarian";
      case "USA":
        return "Beef";
      case "Japan":
        return "Seafood";
    }

    // fallback to time-based mapping
    return mapMealTypeToApiCategory(mealType);
  }

  /// 🔍 SEARCH (WITH DEBOUNCE FROM UI)
  Future<void> search(String query) async {
    if (query.isEmpty) {
      await loadRecipes();
      return;
    }

    state = const AsyncLoading();

    final repo = ref.read(repositoryProvider);
    final isConnected = await ref.read(networkProvider).isConnected;

    try {
      if (isConnected) {
        final data = await repo.searchRecipes(query);
        state = AsyncData(data);
      } else {
        /// 🔥 OFFLINE SEARCH (IMPORTANT)
        final cached = repo.getFavorites(); // or cached recipes

        final filtered = cached
            .where((r) =>
            r.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

        state = AsyncData(filtered);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  /// ❤️ FAVORITES
  Future<void> toggleFavorite(RecipeModel recipe) async {
    final repo = ref.read(repositoryProvider);
    await repo.toggleFavorite(recipe);

    state.whenData((recipes) {
      state = AsyncData([...recipes]);
    });
  }

  List<RecipeModel> getFavorites() {
    return ref.read(repositoryProvider).getFavorites();
  }
}

