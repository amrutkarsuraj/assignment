String getMealType() {
  final hour = DateTime.now().hour;

  if (hour < 11) return "Breakfast";
  if (hour < 16) return "Lunch";
  return "Dinner";
}

String mapMealTypeToApiCategory(String mealType) {
  switch (mealType) {
    case "Breakfast":
      return "Seafood";
    case "Lunch":
      return "Chicken";
    case "Dinner":
      return "Beef";
    default:
      return "Chicken";
  }
}