import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:hrms/widgets/rounded_button.dart';

class CompanyDescriptionScreen extends StatefulWidget {
  const CompanyDescriptionScreen({Key? key}) : super(key: key);

  @override
  State<CompanyDescriptionScreen> createState() =>
      _CompanyDescriptionScreenState();
}

class _CompanyDescriptionScreenState extends State<CompanyDescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController companyDescriptionController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  User? loggedInUser;
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
    CollectionReference users = _firestore.collection('users');
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          // width: MediaQuery.of(context).size.width, //?
          // height: MediaQuery.of(context).size.height,
          decoration: kMainBackgroundColor,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  BuildHeader('Company Description', '/company_settings'),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    width: 381,
                    height: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0x807000E0)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your description';
                        }
                        return null;
                      },
                      controller: companyDescriptionController,
                      style: kNunito500.copyWith(color: Colors.white),
                      cursorColor: Colors.white,
                      maxLength: 800,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Write about your company...',
                        hintStyle: kNunito500.copyWith(color: Colors.white),
                        border: InputBorder.none,
                        counterStyle: kNunito500.copyWith(color: Colors.white),
                      ),
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
                              'company_description':
                                  companyDescriptionController.text
                            }).then((value) => Navigator.of(context)
                                    .pushNamed('/company_home'));
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
}
