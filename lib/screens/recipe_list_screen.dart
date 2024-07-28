import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipe_detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recipes_app/screens/add_recipe_screen.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> recipes = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      DatabaseReference recipesRef =
          FirebaseDatabase.instance.ref().child('recipes');
      DataSnapshot snapshot = await recipesRef.get();

      // Ensure the snapshot value is a Map
      if (snapshot.value != null && snapshot.value is Map) {
        print('snapshot. value is not null');
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        List<Recipe> fetchedRecipes = data.entries.map((entry) {
          Map<dynamic, dynamic> recipeData =
              entry.value as Map<dynamic, dynamic>;
          return Recipe(
            id: entry.key.toString(),
            title: recipeData['title'],
            description: recipeData['description'],
            ingredients: List<String>.from(recipeData['ingredients']),
            steps: List<String>.from(recipeData['steps']),
            imageUrl: recipeData['imageUrl'],
          );
        }).toList();

        // setState(() {
        //   recipes = fetchedRecipes;
        //   isLoading = false; // Set loading to false after data is fetched
        // });
        for (var recipe in fetchedRecipes) {
        print('Recipe ID: ${recipe.id}');
        print('Title: ${recipe.title}');
        print('Description: ${recipe.description}');
        print('Ingredients: ${recipe.ingredients}');
        print('Steps: ${recipe.steps}');
        print('Image URL: ${recipe.imageUrl}');
        print('---');
      }
    } else {
      // Handle empty or invalid data
      setState(() {
        isLoading = false;
      });
      print("No data found or data is not in the expected format.");
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
        title: Center(child: Text('Recipes')),
      ),
      body: recipes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Card(
                  child: ListTile(
                    title: Text(recipe.title),
                    subtitle: Text(recipe.description),
                    leading: Image.network(recipe.imageUrl,
                        width: 50, height: 60, fit: BoxFit.cover),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailScreen(recipe: recipe)),
                      );
                    },
                  ),
                );
              },
            ),
      // body: ListView.builder(
      //   itemCount: recipes.length,
      //   itemBuilder: (context, index) {
      //     final recipe = recipes[index];
      //     return Card(
      //       child: ListTile(
      //         title: Text(recipe.title),
      //         subtitle: Text(recipe.description),
      //         leading: Image.network(recipe.imageUrl, width: 50, height: 60, fit: BoxFit.cover),
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipe: recipe)),
      //           );
      //         },
      //       ),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipeScreen()),
          );
        },
      ),
    );
  }
}
