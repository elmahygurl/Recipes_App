import 'dart:convert'; // For base64 decoding
import 'dart:typed_data'; // For Uint8List
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:recipes_app/Auth/authenticationService.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipe_detail_screen.dart';

class MyRecipesScreen extends StatefulWidget {
  @override
  _MyRecipesScreenState createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  List<Recipe> recipes = [];
  bool isLoading = true;
  final Authenticationservice _authService =
      Authenticationservice(FirebaseAuth.instance);

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final box = Hive.box<Recipe>('user_recipes');
        List<Recipe> fetchedRecipes =
            box.values.where((recipe) => recipe.id == user.uid).toList();

        setState(() {
          recipes = fetchedRecipes;
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $error");
    }
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    try {
      final box = Hive.box<Recipe>('user_recipes');
      await box.delete(recipe.key); //key is the identifier for Hive
      setState(() {
        recipes.remove(recipe);
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error deleting recipe: $error");
    }
  }

  // helper method to decode base64 image string to Uint8List
  Uint8List? _decodeImage(String imageString) {
    try {
      return base64Decode(imageString);
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Recipes')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/back0.PNG'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(child: CircularProgressIndicator()))
          : recipes.isEmpty
              ? Center(child: Text('No recipes available.'))
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('Assets/back0.PNG'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      final imageWidget = recipe.imageType == '0' &&
                              recipe.image.isNotEmpty
                          ? Image.memory(
                              _decodeImage(recipe.image) ?? Uint8List(0),
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.width * 0.6,
                              fit: BoxFit.cover,
                            )
                          : Placeholder();

                      return Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.16,
                          margin: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * 0.006, horizontal: MediaQuery.of(context).size.width * 0.2),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeDetailScreen(recipe: recipe),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(MediaQuery.of(context).size.width * 0.02)),
                                    child: imageWidget,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recipe.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).size.width * 0.03,
                                            ),
                                          ),
                                          SizedBox(height: MediaQuery.of(context).size.height*0.001),
                                          Text(
                                            recipe.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: MediaQuery.of(context).size.width*0.02,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      deleteRecipe(recipe);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
