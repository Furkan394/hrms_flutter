import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({Key? key}) : super(key: key);

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  String description = '';
  TextEditingController positionNameController = TextEditingController();
  TextEditingController locationNameController = TextEditingController();
  TextEditingController jobTypeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
    getCompanyName();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference jobs = _firestore.collection('jobs');

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: kMainBackgroundColor,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BuildHeader('Create a Job Posting', '/company_home'),
                      const SizedBox(height: 10),
                      _buildTextField('Position', 'Enter a position name',
                          positionNameController, 'position'),
                      _buildTextField('Location', 'Enter a location',
                          locationNameController, 'location'),
                      _buildTextField('Job Type', 'Enter a job type',
                          jobTypeController, 'job type'),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(27, 10, 27, 5),
                        child: MarkdownTextInput(
                          (String value) => setState(() => description = value),
                          description,
                          label: 'Job description and general qualifications',
                          maxLines: 10,
                          actions: MarkdownType.values,
                          controller: descriptionController,
                          validators: validator,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildPublishButton(jobs),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter job description';
    }
    return null;
  }

  Widget _buildTextField(String labelText, String placeholder,
      TextEditingController controller, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 5, 27, 15),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $text';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 3),
          labelText: labelText,
          labelStyle: kNunitoSemiBold,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: kNunitoRegular,
        ),
      ),
    );
  }

  CollectionReference jobs = FirebaseFirestore.instance.collection('jobs');
  Widget _buildPublishButton(CollectionReference jobs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130),
      child: Material(
        elevation: 3.0,
        color: const Color(0xFF005FFC),
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              Map<String, dynamic> jobData = {
                'job_id': jobId,
                'position': positionNameController.text,
                'location': locationNameController.text,
                'job-type': jobTypeController.text,
                'description': descriptionController.text,
                'company_name': await getCompanyName(),
                'company_logo_link': await getCompanyLogo(),
                'company_description': await getCompanyDescription(),
                'company_id': await getCompanyId()
              };

              await _firestore
                  .collection('users')
                  .doc(loggedInUser?.uid)
                  .collection('company_job_postings')
                  .doc()
                  .set(jobData);

              await jobs.doc().set(jobData).then(
                  (value) => Navigator.pushNamed(context, '/company_home'));
            }
          },
          minWidth: 200.0,
          height: 30.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Publish', style: kNunito500.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getCompanyId() async {
    return await _firestore
        .collection('users')
        .doc(loggedInUser?.uid)
        .get()
        .then((data) {
      String companyId = data.data()!['uid'];
      return companyId;
    });
  }

  Future<String?> getCompanyName() async {
    return await _firestore
        .collection('users')
        .doc(loggedInUser?.uid)
        .get()
        .then((data) {
      String companyName = data.data()!['company_name'];
      return companyName;
    });
  }

  Future<String?> getCompanyLogo() async {
    return await _firestore
        .collection('users')
        .doc(loggedInUser?.uid)
        .get()
        .then((data) {
      String companyLogo = data.data()!['company_logo_link'];
      return companyLogo;
    });
  }

  Future<String?> getCompanyDescription() async {
    return await _firestore
        .collection('users')
        .doc(loggedInUser?.uid)
        .get()
        .then((data) {
      String companyDescription = data.data()!['company_description'];
      return companyDescription;
    });
  }
}
