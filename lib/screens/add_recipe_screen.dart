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
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add a New Recipe')),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     onPressed: _signOut,
        //   ),
        // ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/back2.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
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
                ImageInputField(
                  onImageChanged: (base64Image) {
                    setState(() {
                      _imageBase64 = base64Image;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
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
                                  ),
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
                SizedBox(height: 20),
                Text(
                  'Steps',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveRecipe,
                  child: Text('Save Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
