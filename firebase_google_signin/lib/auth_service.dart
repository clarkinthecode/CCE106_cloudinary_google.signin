import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '196805640444-q86mb83icvrgksrpl8tsn5kc79fk1r8a.apps.googleusercontent.com',
  );

  Stream<User?> get userStream => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> _saveUserToDatabase(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'last_login': Timestamp.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error saving user: $e");
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        UserCredential credential = await _auth.signInWithPopup(googleProvider);
        if (credential.user != null) {
          await _saveUserToDatabase(credential.user!);
        }
        return credential.user;
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          await _saveUserToDatabase(userCredential.user!);
        }
        return userCredential.user;
      }
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      return null;
    }
  }

  Future<User?> signInOrRegisterWithGoogleEmail(String email) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty) return null;
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: "GoogleUser123!",
      );
      if (cred.user != null) {
        await _saveUserToDatabase(cred.user!);
      }
      return cred.user;
    } catch (_) {
      try {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: cleanEmail,
          password: "GoogleUser123!",
        );
        if (cred.user != null) {
          await _saveUserToDatabase(cred.user!);
        }
        return cred.user;
      } catch (e) {
        debugPrint("Fallback Google email error: $e");
        return null;
      }
    }
  }

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (credential.user != null) {
        await _saveUserToDatabase(credential.user!);
      }
      return credential.user;
    } catch (e) {
      debugPrint("Registration error: $e");
      return null;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (credential.user != null) {
        await _saveUserToDatabase(credential.user!);
      }
      return credential.user;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } catch (e) {
      debugPrint("Reset error: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      try {
        await _googleSignIn.signOut();
      } catch (_) {}
    }
    await _auth.signOut();
  }
}
