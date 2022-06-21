import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/screens/company_screens/company_job_applicants.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:hrms/widgets/job_card.dart';

class CompanyJobPostings extends StatefulWidget {
  const CompanyJobPostings({Key? key}) : super(key: key);

  @override
  State<CompanyJobPostings> createState() => _CompanyJobPostingsState();
}

class _CompanyJobPostingsState extends State<CompanyJobPostings> {
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
                BuildHeader('Job Postings', '/company_home'),
                _buildStreamBuilder(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(loggedInUser?.uid)
            .collection('company_job_postings')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }

          List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot
              .data?.docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

          return Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return JobCard(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CompanyJobApplicants(data: data[index])))
                      },
                      image:
                          NetworkImage(data[index].data()['company_logo_link']),
                      title: data[index].data()['position'],
                      subTitle: data[index].data()['company_name'],
                      location: data[index].data()['location'],
                      jobType: data[index].data()['job-type'],
                    );
                  }),
            ),
          );
        });
  }
}
