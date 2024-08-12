import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:recipes_app/Auth/authenticationService.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/Image/image_input_field.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final Authenticationservice _authService =
      Authenticationservice(FirebaseAuth.instance);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _imageBase64 = '';

  List<String> _newIngredients = [];
  List<String> _newSteps = [];

  Future<void> _saveRecipe() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _formKey.currentState!.validate()) {
      //filter out empty ingredients and steps
      _newIngredients.removeWhere((ingredient) => ingredient.trim().isEmpty);
      _newSteps.removeWhere((step) => step.trim().isEmpty);

      // validate at least one ingredient and one step
      if (_newIngredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please add at least one ingredient'),
        ));
        return;
      }

      if (_newSteps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Please add at least one step'),
        ));

        return;
      }
      _formKey.currentState!.save();

      final newRecipe = Recipe(
        id: user.uid,
        title: _titleController.text,
        description: _descriptionController.text,
        ingredients: _newIngredients,
        steps: _newSteps,
        image: _imageBase64,
        imageType: '0', // 0 for uploading or pic taken
        author: user.email!,
      );

      final box = Hive.box<Recipe>('user_recipes');
      await box.add(newRecipe);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromRGBO(238, 37, 238, 0.795),
        content: Text('Thanks for sharing your masterpiece'),
      ));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final textSize = screenWidth * 0.03;
    final buttonHeight = screenHeight * 0.06;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add a New Recipe')),
      ),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/back2.PNG'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: IntrinsicHeight(
              child: Card(
                surfaceTintColor: Color.fromARGB(172, 70, 216, 65),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(labelText: 'Title'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(labelText: 'Description'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenWidth * 0.005),
                        ImageInputField(
                          onImageChanged: (base64Image) {
                            setState(() {
                              _imageBase64 = base64Image;
                            });
                          },
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Ingredients',
                            style: TextStyle(
                              fontSize: textSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              children: [
                                ..._newIngredients.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String ingredient = entry.value;
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: ingredient,
                                          decoration: InputDecoration(
                                              hintText: 'Enter ingredient',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: screenHeight *
                                                          0.003)),
                                          onChanged: (value) {
                                            setState(() {
                                              _newIngredients[index] = value;
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove_circle_outline),
                                        onPressed: () => setState(() {
                                          _newIngredients.removeAt(index);
                                        }),
                                      ),
                                    ],
                                  );
                                }).toList(),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      _newIngredients.add('');
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Steps',
                            style: TextStyle(
                              fontSize: textSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              children: [
                                ..._newSteps.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String step = entry.value;
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: step,
                                          decoration: InputDecoration(
                                            hintText: 'Enter step',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical:
                                                        screenHeight * 0.003),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              _newSteps[index] = value;
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove_circle_outline),
                                        onPressed: () => setState(() {
                                          _newSteps.removeAt(index);
                                        }),
                                      ),
                                    ],
                                  );
                                }).toList(),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      _newSteps.add('');
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        SizedBox(
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: _saveRecipe,
                            child: Text('Save Recipe',
                                style: TextStyle(fontSize: textSize * 0.7)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
