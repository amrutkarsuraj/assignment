import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';

class DetailScreen extends StatelessWidget {
  final RecipeModel recipe;

  const DetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Hero(
              tag: recipe.id,
              child: Image.network(recipe.image),
            ),
            const SizedBox(height: 20),
            Text(recipe.name, style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}