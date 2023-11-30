import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/user.dart' as my_user;

class AuthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signUp(String email, String password) async {
    UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = authResult.user;
    return user?.uid;
  }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      return user?.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<User?> getUser() async {
    User? user = await _firebaseAuth.currentUser;
    return user;
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<void> addUserData(
      String userId, String email, String username, String bio) async {
    CollectionReference userData =
        FirebaseFirestore.instance.collection('users');

    my_user.Users newUser = my_user.Users(
        userId: userId, username: username, email: email, bio: bio);
    await userData.doc(userId).set(newUser.toMap());
  }

  Future<my_user.Users?> getUserData(String userId) async {
    CollectionReference userData =
        FirebaseFirestore.instance.collection('users');

    DocumentSnapshot docSnap = await userData.doc(userId).get();

    if (docSnap.exists) {
      return my_user.Users.fromMap(docSnap.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
