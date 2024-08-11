import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:convert'; // For base64 decoding

import 'dart:typed_data';

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
        backgroundColor: const Color.fromARGB(255, 255, 177, 177),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/back2.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: _buildImage(),
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
                  color: const Color.fromARGB(255, 26, 23, 22),
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
                      color: const Color.fromARGB(255, 255, 177, 177),
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
                  color: const Color.fromARGB(255, 15, 15, 15),
                ),
              ),
              SizedBox(height: 8),
              ...widget.recipe.steps.asMap().entries.map((entry) {
                int idx = entry.key;
                String step = entry.value;
        
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    tileColor: const Color.fromARGB(255, 255, 177, 177),
                    leading: Icon(
                      _stepsCompleted[idx]
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: const Color.fromARGB(255, 14, 11, 11),
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
      ),
    );
  }

  Widget _buildImage() {
  if (widget.recipe.imageType == '0' && widget.recipe.image.isNotEmpty) {
    try {
      Uint8List imageBytes = base64Decode(widget.recipe.image);
    
      return Stack(
        children: [
          PhotoView(
            imageProvider: MemoryImage(imageBytes),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 2,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Pinch to zoom',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      return Container(
        color: Colors.grey,
        child: Center(
          child: Text('Error decoding image'),
        ),
      );
    }
  } else if (widget.recipe.image.isNotEmpty) {
    return Stack(
      children: [
        PhotoView(
          imageProvider: NetworkImage(widget.recipe.image),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.contained * 2,
          initialScale: PhotoViewComputedScale.contained,
          backgroundDecoration: BoxDecoration(
            color: Colors.transparent,
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Pinch to zoom',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  } else {
    return Container(
      color: Colors.grey,
      child: Center(
        child: Text('No Image Available'),
      ),
    );
  }
}  
}
