class RecipeModel {
  final String id;
  final String name;
  final String image;

  RecipeModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['idMeal'],
      name: json['strMeal'],
      image: json['strMealThumb'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idMeal": id,
      "strMeal": name,
      "strMealThumb": image,
    };
  }
}