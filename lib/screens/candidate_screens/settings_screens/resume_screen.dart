import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:hrms/widgets/bottom_navigation_bar.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({Key? key}) : super(key: key);

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const MyBottomNavigationBar(),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: kMainBackgroundColor,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                BuildHeader('Resume', '/settings'),
                FutureBuilder<DocumentSnapshot>(
                  future: _firestore
                      .collection('users')
                      .doc(loggedInUser?.uid)
                      .get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data?.data() as Map<String, dynamic>;
                      return InkWell(
                          onTap: () {
                            data['resume_link'];
                          },
                          child: const Card(
                            color: Colors.white,
                            child: Text('Resume)'),
                          ));
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
