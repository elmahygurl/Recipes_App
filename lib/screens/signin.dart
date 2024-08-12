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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Incorrect email or password')));
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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final padding = mediaQuery.padding;
    final appBarHeight = mediaQuery.padding.top + kToolbarHeight;
    final borderWidth = screenWidth * 0.005;



    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/back.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.2),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: appBarHeight),
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white, fontSize: screenWidth*0.03),
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(color: Colors.white, fontSize: screenWidth*0.03),
                      iconColor: Color.fromARGB(248, 223, 238, 235),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth*0.01),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white70, width: borderWidth),
                        borderRadius: BorderRadius.circular(screenWidth*0.01),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white70, width: borderWidth),
                        borderRadius: BorderRadius.circular(screenWidth*0.01),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight*0.02),
                  TextFormField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white, fontSize: screenWidth*0.03),
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(100, 255, 255, 255),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white, fontSize: screenWidth*0.03),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth*0.01),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white70, width: borderWidth),
                        borderRadius: BorderRadius.circular(screenWidth*0.01),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white70, width: borderWidth),
                        borderRadius: BorderRadius.circular(screenWidth*0.01),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight*0.02),
                  ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.01),
                      ),
                      elevation: 8,
                      side: BorderSide(
                          color: Color.fromARGB(255, 16, 17, 17), width: borderWidth),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: screenWidth*0.03,
                          color: Color.fromARGB(239, 157, 237, 243)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
