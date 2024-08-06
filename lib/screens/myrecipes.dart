import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipe_detail_screen.dart';

class MyRecipesScreen extends StatefulWidget {
  @override
  _MyRecipesScreenState createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  List<Recipe> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DatabaseReference recipesRef =
            FirebaseDatabase.instance.ref().child('recipes');
        DataSnapshot snapshot =
            await recipesRef.orderByChild('author').equalTo(user.email).get();

        if (snapshot.value != null && snapshot.value is Map) {
          Map<dynamic, dynamic> dataMap =
              snapshot.value as Map<dynamic, dynamic>;

          List<Recipe> fetchedRecipes = [];

          dataMap.forEach((key, value) {
            Map<dynamic, dynamic> recipeData = value;

            fetchedRecipes.add(Recipe(
              id: key,
              title: recipeData['title'],
              description: recipeData['description'],
              ingredients: List<String>.from(recipeData['ingredients']),
              steps: List<String>.from(recipeData['steps']),
              imageUrl: recipeData['imageUrl'],
              author: recipeData['author'],
            ));
          });

          setState(() {
            recipes = fetchedRecipes;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print("No data found or data is not in the expected format.");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog(context, 'User not logged in');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $error");
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
          ? Center(child: CircularProgressIndicator())
          : recipes.isEmpty
              ? Center(child: Text('No recipes available.'))
              : ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return ListTile(
                      title: Text(recipe.title),
                      subtitle: Text(recipe.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                    );
                  },
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
