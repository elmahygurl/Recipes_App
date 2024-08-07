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
  String? imageUrl;

  @HiveField(6)
  Uint8List? imageBlob;
  
  @HiveField(7)
  final String author;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
    this.imageBlob,
    required this.author,
  });
}
