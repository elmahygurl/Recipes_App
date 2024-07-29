import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';

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
    //var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    //var padding = isLandscape ? EdgeInsets.zero : EdgeInsets.all(16.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        //double padding = constraints.maxWidth > 600 ? 10.0 : 16.0;
        //double padding =10;
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Image.network(widget.recipe.imageUrl),
              SizedBox(height: 6),
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              for (var ingredient in widget.recipe.ingredients)
                Text(ingredient, style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 20),
              Text(
                'Steps',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              for (var i = 0; i < widget.recipe.steps.length; i++)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${i + 1}. ${widget.recipe.steps[i]}',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    Checkbox(
                      value: _stepsCompleted[i],
                      onChanged: (bool? value) {
                        _toggleStepCompletion(i);
                      },
                    ),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }
}
