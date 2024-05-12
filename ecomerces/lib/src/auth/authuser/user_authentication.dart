import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      log('Error creating user: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      log(e.credential!.providerId);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      log('Error signing in: $e');
      return null;
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        print('Display name updated successfully in Firebase Authentication.');

        // Update display name in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'displayName': displayName});
        print('Display name updated successfully in Firestore.');
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user is currently signed in.',
        );
      }
    } catch (e) {
      print("Failed to update display name: $e");
      throw FirebaseAuthException(
        code: 'update-display-name-error',
        message: 'Failed to update display name: $e',
      );
    }
  }
}
