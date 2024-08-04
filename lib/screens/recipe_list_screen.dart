import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/Auth/authenticationService.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipe_detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recipes_app/screens/add_recipe_screen.dart';
import 'package:recipes_app/screens/signin.dart';
import 'package:provider/provider.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
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
      DatabaseReference recipesRef =
          FirebaseDatabase.instance.ref().child('recipes');
      DataSnapshot snapshot = await recipesRef.get();
      //print('Snapshot: ${snapshot.value}'); // Debugging: Print the snapshot value

      if (snapshot.value != null && snapshot.value is List) {
        List<dynamic> dataList = snapshot.value as List<dynamic>;

        List<Recipe> fetchedRecipes = [];

        for (var item in dataList) {
          if (item != null && item is Map<dynamic, dynamic>) {
            Map<dynamic, dynamic> recipeData = item;

            fetchedRecipes.add(Recipe(
              id: DateTime.now()
                  .toIso8601String(), // using current timestamp as a unique ID
              title: recipeData['title'],
              description: recipeData['description'],
              ingredients: List<String>.from(recipeData['ingredients']),
              steps: List<String>.from(recipeData['steps']),
              imageUrl: recipeData['imageUrl'],
            ));
          }
        }

        setState(() {
          recipes = fetchedRecipes;
          isLoading = false; //after data is fetched
        });

        // for (var recipe in fetchedRecipes) {
        //   print('Recipe ID: ${recipe.id}');
        //   print('Title: ${recipe.title}');
        //   print('Description: ${recipe.description}');
        //   print('Ingredients: ${recipe.ingredients}');
        //   print('Steps: ${recipe.steps}');
        //   print('Image URL: ${recipe.imageUrl}');
        //   print('---');
        // }
      } else {
        //empty or invalid data
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

  void _signOut() async {
    String message = await _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : recipes.isEmpty
              ? Center(child: Text('No recipes available.'))
              : ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Center(
                        child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 200,
                      margin:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
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
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(12)),
                                child: Image.network(
                                  recipe.imageUrl,
                                  fit: BoxFit.cover,
                                  width: 140,
                                  height: double.infinity,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        recipe.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Provider.of<User?>(context) != null
                  ? AddRecipeScreen()
                  : SignInScreen(),
            ),
          );
        },
      ),
    );
  }
}
