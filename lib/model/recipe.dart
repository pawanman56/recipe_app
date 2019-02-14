import 'package:duration/duration.dart';

enum RecipeType {
  food,
  drink
}

class Recipe {
  final String id;
  final RecipeType type;
  final String name;
  final Duration duration;
  final List<String> ingredients;
  final List<String> preparation;
  final String imageUrl;

  const Recipe({
    this.id,
    this.type,
    this.name,
    this.duration,
    this.ingredients,
    this.preparation,
    this.imageUrl,
  });

  String get getDurationString => prettyDuration(this.duration);

  Recipe.fromMap(Map<String, dynamic> data, String id) : this(
    id: id,
    type: RecipeType.values[data['type']],
    name: data['name'],
    duration: Duration(minutes: data['duration']),
    ingredients: new List<String>.from(data['ingredients']),
    preparation: new List<String>.from(data['preparation']),
    imageUrl: data['imageUrl'],
  );
}
