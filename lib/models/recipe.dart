class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String imageUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.imageUrl,
  });
}
