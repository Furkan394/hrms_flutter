import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:hrms/widgets/bottom_navigation_bar.dart';
import 'package:hrms/widgets/rounded_button.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class CoverLetterScreen extends StatefulWidget {
  const CoverLetterScreen({Key? key}) : super(key: key);

  @override
  State<CoverLetterScreen> createState() => _CoverLetterScreenState();
}

class _CoverLetterScreenState extends State<CoverLetterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController coverLetterController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: const MyBottomNavigationBar(),
      body: SafeArea(
        bottom: false,
        child: Container(
          width: MediaQuery.of(context).size.width, //?
          height: MediaQuery.of(context).size.height,
          decoration: kMainBackgroundColor,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  BuildHeader('Cover Letter', '/settings'),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    width: 381,
                    height: 240,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0x807000E0)),
                    child: TextFormField(
                      validator: validator,
                      controller: coverLetterController,
                      style: kNunito500.copyWith(color: Colors.white),
                      cursorColor: Colors.white,
                      maxLength: 350,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: buildInputDecoration(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: RoundedButton(
                        color: const Color(0xFF005FFC),
                        title: 'Save',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _firestore
                                .collection('users')
                                .doc(loggedInUser?.uid)
                                .update({
                              'cover_letter': coverLetterController.text
                            }).then((value) => Navigator.of(context)
                                    .pushNamed('/profile'));
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      hintText: 'Enter your cover letter...',
      hintStyle: kNunito500.copyWith(color: Colors.white),
      border: InputBorder.none,
      counterStyle: kNunito500.copyWith(color: Colors.white),
    );
  }

  String? validator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your cover letter';
    }
    return null;
  }
}
