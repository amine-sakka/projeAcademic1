import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

abstract class BaseAuth {
  //making the code moduble modulel something just to make my code better -_- 
  Future<String> signInWithEmailAndPassword (String email,String password);
  Future <String> createUserWithEmailAndPassword(String email,String password);
  Future <String> currentUser();
  Future<void> signOut();
}
class Auth implements BaseAuth{
  Future<String> signInWithEmailAndPassword (String email,String password) async
  {
    //login stuff
    AuthResult result= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,password: password); 
    FirebaseUser user=result.user; //fire base user
    return(user.uid);
  }
  Future <String> createUserWithEmailAndPassword(String email,String password) async
  {
    //register function 
    AuthResult result =await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email,password:password);
    FirebaseUser user=result.user;
    return(user.uid);

  } 
  Future <String> currentUser() async{
    //return the id of the user of the current user
    FirebaseUser user =await FirebaseAuth.instance.currentUser();
    return(user.uid);
  }
   Future<void> signOut() async {
     //sign out of the app
    return await FirebaseAuth.instance.signOut();
  }
}