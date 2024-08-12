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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final imageHeight = screenHeight * 0.4;
    final fontSizeTitle = screenWidth * 0.04;
    final fontSizeSubtitle = screenWidth * 0.026;
    final ingredientPadding = EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02, vertical: screenHeight * 0.008);
    final cardMargin = EdgeInsets.symmetric(vertical: screenHeight * 0.008);

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
          padding: EdgeInsets.all(screenWidth * 0.015),
          child: ListView(
            children: [
              Container(
                height: imageHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  child: _buildImage(screenWidth, screenHeight),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'By ${widget.recipe.author}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: fontSizeSubtitle,
                ),
              ),
              SizedBox(height: screenHeight * 0.004),
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 26, 23, 22),
                ),
              ),
              SizedBox(height: screenHeight * 0.001),
              Wrap(
                spacing: screenWidth * 0.009,
                runSpacing: screenWidth * 0.02,
                children: widget.recipe.ingredients.map((ingredient) {
                  return Container(
                    padding: ingredientPadding,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      color: const Color.fromARGB(255, 255, 177, 177),
                    ),
                    child: Text(
                      ingredient,
                      style: TextStyle(fontSize: fontSizeSubtitle * 0.9),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Steps',
                style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 15, 15, 15),
                ),
              ),
              SizedBox(height: screenHeight * 0.001),
              ...widget.recipe.steps.asMap().entries.map((entry) {
                int idx = entry.key;
                String step = entry.value;

                return Card(
                  margin: cardMargin,
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
                      style: TextStyle(fontSize: fontSizeSubtitle * 0.9),
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

  Widget _buildImage(double allWidth, double allHeight) {
    final paddingValue = allWidth * 0.02;
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
              bottom: paddingValue,
              right: paddingValue,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: paddingValue / 4, vertical: paddingValue/2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(allWidth*0.006),
                ),
                child: Text(
                  'Pinch to zoom',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: allWidth*0.02,
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
            bottom: paddingValue,
            right: paddingValue,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: paddingValue / 4, vertical: paddingValue/2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(allWidth*0.006),
              ),
              child: Text(
                'Pinch to zoom',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: allWidth*0.02,
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
