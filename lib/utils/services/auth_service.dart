import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrms/screens/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.idTokenChanges();

  Future<Object> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (e) {
      return e;
    }
  }

  Future<Object> signUpForIndividual(
      String firstName, String lastName, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .set({
          'uid': user.uid,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'role': 'candidate',
          'cover_letter': 'Add your cover letter...', //default
          'profession': '', //default
          'phone_number': '', //default
          'resume_link': 'url', //default
          'image_link':
              'https://cdn-icons-png.flaticon.com/512/848/848043.png' //default
        });
      });
      return "Signed Up";
    } catch (e) {
      return e;
    }
  }

  Future<Object> signUpForCompany(String companyName, String webAddress,
      String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .set({
          'uid': user.uid,
          'company_name': companyName,
          'web_address': webAddress,
          'email': email,
          'password': password,
          'role': 'company',
          'company_description': 'Write about your company...', //default
          'company_logo_link':
              'https://cdn-icons-png.flaticon.com/512/848/848043.png' //default
        });
      });
      return "Signed Up";
    } catch (e) {
      return e;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut().then((value) => Navigator.of(context)
        .pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false));
  }

  // Future getCurrentUser() async {
  //   DocumentSnapshot document = await Firestore.instance.collection('users').document(FirebaseUser().uid).get();
  //   name = document.data['name']
  // }
}
