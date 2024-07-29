import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes_app/screens/recipe_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes App',
      theme: ThemeData(
        primaryColor: Color.fromARGB(201, 145, 91, 105),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(201, 247, 150, 174),
          secondary: const Color.fromARGB(255, 230, 214, 167),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Recipes App')),
          backgroundColor: Color.fromARGB(255, 231, 206, 198)
        ),
        body: FutureBuilder(
          future: _fApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('Firebase initialization error: ${snapshot.error}');
              return Center(child: Text("Something went wrong with Firebase"));
            } else if (snapshot.connectionState == ConnectionState.done) {
              return RecipeListScreen();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
