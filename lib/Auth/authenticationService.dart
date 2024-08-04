import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticationservice extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  Authenticationservice(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();  //to listen to change of state, user logged in or out
  Future<String> signIn({required String email, required String password}) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return "Signed in successfully";

    }on FirebaseAuthException catch(e){
      return e.message.toString();
    } 
  }

  Future<String> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners(); // Notify listeners after sign-up
      return "Signed up successfully";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners(); //notify listeners after sign-out
      return "Signed out successfully";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }


}
