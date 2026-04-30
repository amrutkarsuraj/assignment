import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/recipe_model.dart';
import 'favorite_icon.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final bool isFav;
  final VoidCallback onFavTap;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isFav,
    required this.onFavTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          onTap: onFavTap,
        ),
        onTap: onTap,
      ),
    );
  }
}