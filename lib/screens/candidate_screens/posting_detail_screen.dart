import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:hrms/widgets/posting_detail_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostingDetailScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  const PostingDetailScreen({required this.data});

  @override
  State<PostingDetailScreen> createState() => _PostingDetailScreenState();
}

class _PostingDetailScreenState extends State<PostingDetailScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  FToast? fToast;

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
    fToast = FToast();
    fToast?.init(context);
  }

  Future<Map<String, dynamic>> getCurrentUserInfo() async {
    return await _firestore
        .collection('users')
        .doc(loggedInUser?.uid)
        .get()
        .then((data) {
      Map<String, dynamic> userData = {
        'first_name': data.data()!['first_name'],
        'last_name': data.data()!['last_name'],
        'email': data.data()!['email'],
        'cover_letter': data.data()!['cover_letter'],
        'profession': data.data()!['profession'],
        'phone_number': data.data()!['phone_number'],
        'resume_link': data.data()!['resume_link'],
        'image_link': data.data()!['image_link'],
        'job_id': widget.data.data()['job_id']
      };
      return userData;
    });
  }

  Future<Map<String, dynamic>> getCurrentJob() async {
    return await _firestore
        .collection('jobs')
        .doc(widget.data.id)
        .get()
        .then((data) {
      Map<String, dynamic> jobData = {
        'company_logo_link': data.data()!['company_logo_link'],
        'position': data.data()!['position'],
        'company_name': data.data()!['company_name'],
        'location': data.data()!['location'],
        'job-type': data.data()!['job-type'],
      };
      return jobData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: buildPostingDetailNavigationBar(context, () async {
        await _firestore
            .collection('users')
            .doc(loggedInUser?.uid)
            .collection('saved_postings')
            .doc()
            .set(await getCurrentJob())
            .then((value) => fToast?.showToast(
                  child: toast("Saved!"),
                  toastDuration: const Duration(seconds: 3),
                ));
      }, () async {
        // List<dynamic> applicants = [];
        // applicants.add(await getCurrentUserInfo());
        // Map<String, dynamic> applicantsData = {
        //   'applicants': FieldValue.arrayUnion(applicants)
        // };

        // await jobs
        //     .doc(widget.data.id)
        //     .collection('applicants')
        //     .doc()
        //     .set(await getCurrentUserInfo())
        //     .then((value) => fToast?.showToast(
        //           child: toast("Successfully applied!"),
        //           toastDuration: const Duration(seconds: 3),
        //       ));
        await _firestore
            .collection('users')
            .doc(loggedInUser?.uid)
            .collection('candidate_applications')
            .doc()
            .set(await getCurrentJob());

        await _firestore
            .collection('users')
            .doc(widget.data.data()['company_id'])
            .collection('applicants')
            .doc()
            .set(await getCurrentUserInfo())
            .then((value) => fToast?.showToast(
                  child: toast("Successfully applied!"),
                  toastDuration: const Duration(seconds: 3),
                ));
      }),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: kMainBackgroundColor,
          child: Column(
            children: [
              BuildHeader(' ', '/home'),
              _buildJobInfoArea(),
            ],
          ),
        ),
      ),
    );
  }

  toast(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check),
          const SizedBox(
            width: 12.0,
          ),
          Text(message, style: kNunito500.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  Expanded _buildJobInfoArea() {
    return Expanded(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      NetworkImage(widget.data.data()['company_logo_link']),
                ),
                title: Text('${widget.data.data()['position']}'),
                subtitle: Text('${widget.data.data()['company_name']}')),
          ),
          const Divider(
            indent: 32,
            endIndent: 32,
            color: Colors.grey,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 32.0),
            child: Text('Location'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 9),
            child: Container(
              width: 285,
              height: 24,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: const Color(0xFFF3F3F3)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 9.0),
                  child: Text('${widget.data.data()['location']}',
                      style: kNunitoRegular),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 32.0),
            child: Text('Job Type'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 9),
            child: Container(
              width: 285,
              height: 24,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: const Color(0xFFF3F3F3)),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Text('${widget.data.data()['job-type']}',
                        style: kNunitoRegular),
                  )),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              'Company Description',
              style: kNunitoSemiBold.copyWith(fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
            child: Text(
              '${widget.data.data()['company_description']}',
              style: kNunitoRegular.copyWith(fontSize: 13),
            ),
          ),
          const Divider(
            indent: 32,
            endIndent: 32,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Text(
              'Job Description and General Qualifications',
              style: kNunitoSemiBold.copyWith(fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
            child: Text(
              '${widget.data.data()['description']}',
              style: kNunitoRegular.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
