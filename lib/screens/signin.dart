import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes_app/Auth/authenticationService.dart';
import 'package:recipes_app/screens/add_recipe_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Authenticationservice _authService =
      Authenticationservice(FirebaseAuth.instance);

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      String message = await _authService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

      if (message == "Signed in successfully") {
        //clear after sign-in
        // _emailController.clear();
        // _passwordController.clear();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AddRecipeScreen()),
        // );
        print('logged in successfully');
      } else {
        print('didnt log in');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Incorrect email or password')));
      }
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sign In')),
        backgroundColor: const Color.fromARGB(255, 233, 124, 91),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signIn,
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(
//     home: SignInScreen(),
//   ));
// }
