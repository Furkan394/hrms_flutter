import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/build_header.dart';

// ignore: must_be_immutable
class ApplicantsCoverLetter extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>>? data;

  const ApplicantsCoverLetter({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('${data!.data()['first_name']}\'s Cover Letter'),
          backgroundColor: Colors.blue),
      body: SafeArea(
        child: Container(
          decoration: kMainBackgroundColor,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.fromLTRB(17, 17, 17, 10),
                  height: 500,
                  child: Text('${data!.data()['cover_letter']}',
                      style: kNunitoRegular.copyWith(
                          fontSize: 15, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
