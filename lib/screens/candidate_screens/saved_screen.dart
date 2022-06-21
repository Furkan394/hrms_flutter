import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/screens/candidate_screens/posting_detail_screen.dart';
import 'package:hrms/widgets/bottom_navigation_bar.dart';
import 'package:hrms/widgets/job_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  List<dynamic> savedJobPostings = [];

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

  // Future<List<dynamic>> getSavedJobs() {
  //   return _firestore
  //       .collection('users')
  //       .doc(loggedInUser?.uid)
  //       .get()
  //       .then((data) {
  //     List<dynamic> savedJobPostings =
  //         List.from(data.get('saved_job_postings') as List);
  //     return savedJobPostings;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const MyBottomNavigationBar(),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: kMainBackgroundColor,
          child: DefaultTabController(
            length: 2,
            child: Flex(direction: Axis.vertical, children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 65.0),
                      child: TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          labelStyle: kNunitoSemiBold.copyWith(fontSize: 15),
                          padding: const EdgeInsets.fromLTRB(27, 0, 27, 5),
                          indicator: kMenuTopNameColor.copyWith(
                              borderRadius: BorderRadius.circular(
                            5.0,
                          )),
                          tabs: const [
                            Tab(
                              height: 27,
                              text: 'Saved Postings',
                            ),
                            Tab(
                              height: 27,
                              text: 'Applications',
                            ),
                          ]),
                    ),
                    const Divider(
                      thickness: 0.5,
                      indent: 27,
                      endIndent: 27,
                      color: Color(0x95ADADAD),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TabBarView(
                        children: [
                          _buildSavedJobPostings(),
                          _buildCandidateApplications(),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  _buildSavedJobPostings() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(loggedInUser?.uid)
            .collection('saved_postings')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No saved job postings"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }

          // List savedJobPostings =
          //     List.from(snapshot.data!.get('saved_job_postings'));

          List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot
              .data!.docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return JobCard(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PostingDetailScreen(data: data[index])))
                  },
                  image: NetworkImage(data[index].data()['company_logo_link']),
                  title: data[index].data()['position'],
                  subTitle: data[index].data()['company_name'],
                  location: data[index].data()['location'],
                  jobType: data[index].data()['job-type'],
                );
              });
        });
  }

  _buildCandidateApplications() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(loggedInUser?.uid)
            .collection('candidate_applications')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No applications"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }

          List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot
              .data!.docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return JobCard(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PostingDetailScreen(data: data[index])))
                  },
                  image: NetworkImage(data[index].data()['company_logo_link']),
                  title: data[index].data()['position'],
                  subTitle: data[index].data()['company_name'],
                  location: data[index].data()['location'],
                  jobType: data[index].data()['job-type'],
                );
              });
        });
  }
}
