import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late List<bool> _stepsCompleted;

  @override
  void initState() {
    super.initState();
    _stepsCompleted = List<bool>.filled(widget.recipe.steps.length, false);
  }

  void _toggleStepCompletion(int index) {
    setState(() {
      _stepsCompleted[index] = !_stepsCompleted[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        backgroundColor: const Color.fromARGB(255, 233, 124, 91),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: PhotoView(
                  imageProvider: NetworkImage(widget.recipe.imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 2,
                  initialScale: PhotoViewComputedScale.contained,
                  backgroundDecoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'By ${widget.recipe.author}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: widget.recipe.ingredients.map((ingredient) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: Text(
                    ingredient,
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Steps',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 8),
            ...widget.recipe.steps.asMap().entries.map((entry) {
              int idx = entry.key;
              String step = entry.value;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(
                    _stepsCompleted[idx]
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: Colors.deepOrange,
                  ),
                  title: Text(
                    '${idx + 1}. $step',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    _toggleStepCompletion(idx);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
