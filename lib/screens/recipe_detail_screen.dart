import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  // Widget build(BuildContext context) {
  //   // var deviceData = MediaQuery.of(context);
  //   // var screenSize = deviceData.size;
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(recipe.title),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: Center(
  //         child: ListView(
  //           //crossAxisAlignment: CrossAxisAlignment.start,
            
  //           children: [
  //             Image.network(recipe.imageUrl),
  //             SizedBox(height: 16),
  //             Text(
  //               'Ingredients',
  //               style: Theme.of(context).textTheme.displayMedium,
  //             ),
  //             for (var ingredient in recipe.ingredients)
  //               Text(ingredient,style:Theme.of(context).textTheme.bodyLarge),
  //             SizedBox(height: 20),
  //             Text(
  //               'Steps',
  //               style: Theme.of(context).textTheme.displayMedium,
  //             ),
  //             for (var i = 0; i < recipe.steps.length; i++)
  //               Text(
  //                 '${i + 1}. ${recipe.steps[i]}',
  //                 style: Theme.of(context).textTheme.bodyLarge,
  //               ),
            
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    //var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    //var padding = isLandscape ? EdgeInsets.zero : EdgeInsets.all(16.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          //double padding = constraints.maxWidth > 600 ? 10.0 : 16.0;
          //double padding =10;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                Image.network(recipe.imageUrl),
                SizedBox(height: 6),
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                for (var ingredient in recipe.ingredients)
                  Text(ingredient, style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: 20),
                Text(
                  'Steps',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                for (var i = 0; i < recipe.steps.length; i++)
                  Text(
                    '${i + 1}. ${recipe.steps[i]}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
