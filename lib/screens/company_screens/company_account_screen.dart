import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/utils/services/storage_service.dart';
import 'package:hrms/widgets/rounded_button.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CompanyAccountScreen extends StatefulWidget {
  const CompanyAccountScreen({Key? key}) : super(key: key);

  @override
  State<CompanyAccountScreen> createState() => _CompanyAccountScreenState();
}

class _CompanyAccountScreenState extends State<CompanyAccountScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  File? companyLogo;
  UploadTask? task;

  TextEditingController companyNameController = TextEditingController();
  TextEditingController webAddressController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<String?> doAutoFillAccountInfos() async {
    return await _firestore
        .collection('users')
        .doc(loggedInUser?.uid)
        .get()
        .then((data) {
      companyNameController.text = data.data()!['company_name'];
      webAddressController.text = data.data()!['web_address'];
      emailController.text = data.data()!['email'];
      return null;
    });
  }

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
    doAutoFillAccountInfos();
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
            child: FutureBuilder(
                future:
                    _firestore.collection('users').doc(loggedInUser?.uid).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return ListView(
                      children: [
                        BuildHeader('Account', '/company_settings'),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () => getCompanyLogo(),
                                child: buildCompanyLogoContainer(context, data),
                              ),
                              buildCircleEditButton(context),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        _buildTextField(
                            "Company Name",
                            "Enter your company "
                                "name",
                            companyNameController),
                        _buildTextField("Web Address", "Enter your web address",
                            webAddressController),
                        _buildTextField(
                            "E-mail",
                            "Enter your "
                                "e-mail",
                            emailController),
                        const SizedBox(height: 15),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 110.0),
                          child: RoundedButton(
                              color: const Color(0xFF005FFC),
                              title: 'Save',
                              onPressed: () async {
                                await _firestore
                                    .collection('users')
                                    .doc(loggedInUser?.uid)
                                    .update({
                                  'company_name': companyNameController.text,
                                  'web_address': webAddressController.text,
                                  'email': emailController.text,
                                }).then((value) => Navigator.of(context)
                                        .pushNamed('/company_home'));
                              }),
                        )
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
        ),
      ),
    );
  }

  Positioned buildCircleEditButton(BuildContext context) {
    return Positioned(
        bottom: 5,
        right: 3,
        child: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 1.5,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            color: Colors.blueAccent,
          ),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 18,
          ),
        ));
  }

  Container buildCompanyLogoContainer(
      BuildContext context, Map<String, dynamic> data) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).scaffoldBackgroundColor),
          boxShadow: [
            BoxShadow(
                spreadRadius: 2,
                blurRadius: 5,
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 8))
          ],
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: companyLogo == null
                  ? NetworkImage(data['company_logo_link'])
                  : companyLogo != null
                      ? FileImage(companyLogo!)
                      : const AssetImage('assets/images/avatar'
                          '.png') as ImageProvider)),
    );
  }

  Future getCompanyLogo() async {
    try {
      final logo = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (logo == null) return;

      final logoTemporary = File(logo.path);
      setState(() => companyLogo = logoTemporary);
    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }

    uploadLogo();
    return FileImage(companyLogo!);
  }

  Future uploadLogo() async {
    if (companyLogo == null) return;

    final logoName = basename(companyLogo!.path);
    final destination = 'company_logos/$logoName';

    task = FirebaseStorageApi.uploadFile(destination, companyLogo!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    final logoUrl = urlDownload.toString();

    await _firestore
        .collection('users')
        .doc(loggedInUser?.uid)
        .update({'company_logo_link': logoUrl});

    print('Download-Link: $logoUrl');
  }
}

Widget _buildTextField(
  String labelText,
  String placeholder,
  TextEditingController? controller,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(27, 5, 27, 8),
    child: TextFormField(
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
