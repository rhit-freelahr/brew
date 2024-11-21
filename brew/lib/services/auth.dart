import 'package:brew/models/userData.dart';
import 'package:brew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BrewUser? _userFromFirebaseUser(User? user) {
    return user != null ? BrewUser(uid: user.uid) : null;
  }

  Stream<BrewUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<BrewUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<BrewUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<BrewUser?> registerWithEmailAndPassword(
      String email, String password, String type) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print(user);
      if (user != null) {
        await DatabaseService(uid: user.uid).updateUserType(type);
      }
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error.toString());
      throw Exception('Sign out failed');
    }
  }
}
