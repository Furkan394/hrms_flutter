import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/screens/company_screens/applicants_cover_letter.dart';
import 'package:hrms/screens/company_screens/applicants_resume_view.dart';
import 'package:hrms/widgets/applicant_card.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:hrms/widgets/job_card.dart';

class CompanyJobApplicants extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  const CompanyJobApplicants({Key? key, required this.data}) : super(key: key);

  @override
  State<CompanyJobApplicants> createState() => _CompanyJobApplicantsState();
}

class _CompanyJobApplicantsState extends State<CompanyJobApplicants> {
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
                BuildHeader('Applicants', '/company_job_postings'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                  child: Text(
                      'You can view the applicant\'s resume by tapping the '
                      'cards.',
                      style: kNunitoSemiBold.copyWith(color: Colors.green),
                      textAlign: TextAlign.center),
                ),
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
            .collection('applicants')
            .where('job_id', isEqualTo: widget.data.data()['job_id'])
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

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ApplicantCard(
                        onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ResumeView(data: data[index])))
                            },
                        onTapCoverLetter: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ApplicantsCoverLetter(
                                              data: data[index])))
                            },
                        firstName: data[index].data()['first_name'],
                        lastName: data[index].data()['last_name'],
                        profession: data[index].data()['profession'],
                        email: data[index].data()['email'],
                        phoneNumber: data[index].data()['phone_number'],
                        profileImage:
                            NetworkImage(data[index].data()['image_link']));
                  }),
            ),
          );
        });
  }
}
