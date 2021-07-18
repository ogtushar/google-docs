import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    final User? user = userCredential.user;
    debugPrint("User SignIn Details: " + user.toString());
    if (user != null) {
      await addUserToCollection(user);
    }
  }

  addUserToCollection(User user) async {
    await _firestore.collection("users").doc(user.uid).set({
      "displayName": user.displayName,
      "email": user.email,
      "phoneNumber": user.phoneNumber,
      "photoURL": user.photoURL,
      "uid": user.uid,
    });
  }

  signOutWithGoogle() async {
    debugPrint("Sign Out Triggred");
    await _googleSignIn.disconnect();
    await _firebaseAuth.signOut();
  }
}
