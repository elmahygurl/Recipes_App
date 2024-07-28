import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipes_app/screens/recipe_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //ensures that the binding is initialized before Firebase is initialized.
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  String realTimeVal = '0';
  @override
  Widget build(BuildContext context) {
    DatabaseReference _testRef = FirebaseDatabase.instance.ref().child('id');
    //listen to firebase realtime database value
    _testRef.onValue.listen(
      (event){
        setState(() {
          realTimeVal = event.snapshot.value.toString();
        });
      }
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes App',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 110, 116, 165),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(255, 107, 112, 160),
          secondary: const Color.fromARGB(255, 230, 214, 167),
        ),
      ),
      //the aim of the next code snippet was to check if firebase was succesfully initialized 
      home: Scaffold(
        body: FutureBuilder(
          future: _fApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something wrong with firebase");
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  Text("Firebase initialised"),
                  Text("Real time id = $realTimeVal"),
                ],
              );
              
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        
      ),
      // home:
      //      //Text("Real time id = $realTimeVal"),
      // RecipeListScreen(),
    );
  }
}
