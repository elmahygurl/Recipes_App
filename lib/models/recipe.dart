import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'recipe.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<String> ingredients;

  @HiveField(4)
  final List<String> steps;

  @HiveField(5)
  final String image;

  @HiveField(6)
  final String imageType;  //0 for upload or user entry and 1 for database or API
  
  @HiveField(7)
  final String author;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.image,
    required this.imageType,
    required this.author,
  });
}
