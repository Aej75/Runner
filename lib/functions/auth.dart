import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth{
  Future<String?> signInWithEmailAndPassword(String email, String password);
  Future<String?> createUserWithEmailAndPassword(String email, String password);
}

class Auth implements BaseAuth{

  @override
  Future<String?> createUserWithEmailAndPassword(String email, String password)async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    return uid;
  }

  @override
  Future<String?> signInWithEmailAndPassword(String email, String password) async{
    FirebaseAuth auth = FirebaseAuth.instance;             //these codes will get the user id (UID)
    final User? user = auth.currentUser;                   //from the users using the User class
    final uid= user?.uid;                                  //as mentioned here.
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return uid;
  }
}