import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes_app/screens/recipe_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/Auth/authenticationService.dart';
import 'package:recipes_app/screens/signin.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // StreamProvider to listen for authentication state changes and provide current User object to widget tree.
    return StreamProvider<User?>(
      create: (context) => Authenticationservice(FirebaseAuth.instance).authStateChanges,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recipes App',
        theme: ThemeData(
          primaryColor: Color.fromARGB(201, 145, 91, 105),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color.fromARGB(201, 247, 150, 174),
            secondary: const Color.fromARGB(255, 230, 214, 167),
          ),
        ),
        home: AuthGate(),
      ),
    );
  }
}

//widget that checks the current authentication state
class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    print('user now is $user');
    if (user == null) {
      // user not logged in
      return SignInScreen();
    } else {
      // user logged in
      return RecipeListScreen();
    }
  }
}