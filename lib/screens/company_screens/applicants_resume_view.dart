import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:hrms/constants.dart';

// ignore: must_be_immutable
class ResumeView extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>>? data;

  ResumeView({Key? key, this.data}) : super(key: key);

  @override
  State<ResumeView> createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  late PDFDocument document;
  bool isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      document = await PDFDocument.fromURL(widget.data!.data()['resume_link']);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.data!.data()['first_name']}\'s Resume'),
      ),
      body: Container(
        decoration: kMainBackgroundColor,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : PDFViewer(document: document),
      ),
    );
  }
}
