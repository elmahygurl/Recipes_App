import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/Auth/authenticationService.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/myrecipes.dart';
import 'package:recipes_app/screens/recipe_detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recipes_app/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/Encrypttt/aes_helper.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen>
    with SingleTickerProviderStateMixin {
  List<Recipe> recipes = [];
  bool isLoading = true;
  final Authenticationservice _authService =
      Authenticationservice(FirebaseAuth.instance);
  final AESHelper aesHelper = AESHelper();
  AnimationController? _animationController;

  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    fetchRecipes();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 15)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });


    _animationController!.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController?.dispose();

    super.dispose();
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
              image: recipeData['imageUrl'],
              imageType: '1', //fetched from firebase
              author: recipeData['author'],
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

  // helpwer function to convert JSON string to Recipe object
  Recipe deserializeRecipe(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Recipe(
      id: DateTime.now().toIso8601String(),
      title: jsonMap['title'],
      description: jsonMap['description'],
      ingredients: List<String>.from(jsonMap['ingredients']),
      steps: List<String>.from(jsonMap['steps']),
      image: jsonMap['imageUrl'],
      imageType: '1',
      author: jsonMap['author'],
    );
  }

  void _showRecipeOfTheDayDialog() async {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter your lucky number'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Lucky number'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String input = controller.text;
              if (input.isEmpty || !RegExp(r'^\d+$').hasMatch(input)) {
                _showErrorDialog(context, 'Please enter a valid lucky number');
              } else {
                try {
                  int userInput = int.parse(input);
                  Random random = Random();
                  int mappedNumber = 11 + random.nextInt(9);

                  String recipeOfTheDay =
                      await aesHelper.getRecipeOfTheDay(mappedNumber);

                  Recipe recipe = deserializeRecipe(recipeOfTheDay);
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(recipe: recipe),
                    ),
                  );
                } catch (e) {
                  _showErrorDialog(
                      context, 'Error fetching recipe. Please try again. $e');
                }
              }
            },
            child: Text('Get Recipe'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final imageWidth = screenWidth * 0.2;
    final imageHeight = screenHeight * 0.2;
    final fontSizeTitle = screenWidth * 0.03;
    final fontSizeDescription = screenWidth * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Recipe List')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.restaurant),
            onPressed: () {
              //Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyRecipesScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
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
                      return Center(
                          child: Container(
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.17,
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.004,
                            horizontal: screenWidth * 0.05),
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
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.horizontal(
                                      left:
                                          Radius.circular(screenWidth * 0.03)),
                                  child: _buildRecipeImage(
                                      recipe, imageWidth, imageHeight),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.02),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe.title,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSizeTitle,
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Text(
                                          recipe.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: fontSizeDescription,
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Text(
                                          'By: ${recipe.author}',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: screenWidth * 0.018,
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
                ),
      floatingActionButton: AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_animation!.value),
            child: FloatingActionButton(
              backgroundColor: Color.fromARGB(150, 223, 20, 114),
              child: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Color.fromARGB(251, 190, 119, 154),
                  context: context,
                  builder: (context) => Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.add),
                        title: Text('Add Recipe'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddRecipeScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Get Recipe of the Day'),
                        onTap: () {
                          Navigator.pop(context);
                          _showRecipeOfTheDayDialog();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

Widget _buildRecipeImage(Recipe recipe, double width, double height) {
  // If imageType is 0, use the base64-encoded string
  if (recipe.imageType == '0' && recipe.image.isNotEmpty) {
    try {
      Uint8List imageBytes = base64Decode(recipe.image);
      return Image.memory(
        imageBytes,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } catch (e) {
      // Handle decoding errors
      return Container(
        width: width,
        height: height,
        color: Colors.grey,
        child: Center(
          child: Text('Error decoding image'),
        ),
      );
    }
  }
  // If imageType is 1, use the URL string - i didnt put recipe.imageType == 1 &&  cuz in APi its not set
  else if (recipe.image.isNotEmpty) {
    return Image.network(
      recipe.image,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
  // No image available
  else {
    return Container(
      width: width,
      height: height,
      color: Colors.grey,
      child: Center(
        child: Text('No Image Available'),
      ),
    );
  }
}
