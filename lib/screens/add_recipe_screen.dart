import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  final _imageUrlController = TextEditingController();

  List<String> _NewIngredients = [];
  List<String> _NewSteps = [];

  void _addIngredient() {
    setState(() {
      _NewIngredients.add('');
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _NewIngredients.removeAt(index);
    });
  }

  void _addStep() {
    setState(() {
      _NewSteps.add('');
    });
  }

  void _signOut() async {
    String message = await _authService.signOut();
  }

  void _removeStep(int index) {
    setState(() {
      _NewSteps.removeAt(index);
    });
  }

  Future<void> _saveRecipe() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newRecipe = Recipe(
        id: user.uid,
        title: _titleController.text,
        description: _descriptionController.text,
        ingredients: _NewIngredients,
        steps: _NewSteps,
        imageUrl: _imageUrlController.text,
        author: user.email!,
      );

      print(newRecipe);
      final box = Hive.box<Recipe>('user_recipes');
      await box.add(newRecipe);

      //  for saving in realtime database on Firebase
      // DatabaseReference recipesRef =
      //     FirebaseDatabase.instance.ref().child('recipes');
      // await recipesRef.push().set({
      //   'id': user.uid,
      //   'title': _titleController.text,
      //   'description': _descriptionController.text,
      //   'ingredients': _NewIngredients,
      //   'steps': _NewSteps,
      //   'imageUrl': _imageUrlController.text,
      //   'author': user.email,
      // });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromRGBO(238, 37, 238, 0.795),
          content: Text('Thanks for sharing your masterpiece')));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Recipe'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
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
              ImageInputField(controller: _imageUrlController),
              SizedBox(height: 20),
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ..._NewIngredients.asMap().entries.map((entry) {
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
                            _NewIngredients[index] = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () => _removeIngredient(index),
                    ),
                  ],
                );
              }).toList(),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: _addIngredient,
              ),
              SizedBox(height: 20),
              Text(
                'Steps',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ..._NewSteps.asMap().entries.map((entry) {
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
                            _NewSteps[index] = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () => _removeStep(index),
                    ),
                  ],
                );
              }).toList(),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: _addStep,
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
    );
  }
}
