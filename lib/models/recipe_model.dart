class RecipeModel {

  int id;
  String title;
  String category;
  String ingredients;
  String steps;

  RecipeModel({
    required this.id,
    required this.title,
    required this.category,
    required this.ingredients,
    required this.steps,
  });

  factory RecipeModel.fromJson(
      Map<String, dynamic> json) {

    return RecipeModel(
      id: int.parse(json['id']),
      title: json['title'],
      category: json['category'],
      ingredients: json['ingredients'],
      steps: json['steps'],
    );
  }
}