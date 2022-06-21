import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hrms/utils/services/storage_service.dart';
import 'package:hrms/widgets/bottom_navigation_bar.dart';
import 'package:hrms/widgets/rounded_button.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  File? profileImage;
  UploadTask? task;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Future<String?> doAutoFillAccountInfos() async {
    return await _firestore
        .collection('users')
        .doc(loggedInUser?.uid)
        .get()
        .then((data) {
      firstNameController.text = data.data()!['first_name'];
      lastNameController.text = data.data()!['last_name'];
      emailController.text = data.data()!['email'];
      professionController.text = data.data()!['profession'];
      phoneNumberController.text = data.data()!['phone_number'];
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
            child: FutureBuilder(
                future:
                    _firestore.collection('users').doc(loggedInUser?.uid).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return ListView(
                      children: [
                        BuildHeader('Account', '/settings'),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              InkWell(
                                  onTap: () => getProfileImage(),
                                  child: buildProfileImageContainer(
                                      context, data)),
                              buildCircleEditButton(context),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        _buildTextField("First Name", "Enter your first name",
                            firstNameController),
                        _buildTextField("Last Name", "Enter your last name",
                            lastNameController),
                        _buildTextField(
                            "E-mail",
                            "Enter your "
                                "e-mail",
                            emailController),
                        _buildTextField("Profession", "Enter your profession",
                            professionController),
                        _buildTextField("Phone number",
                            "Enter your phone number", phoneNumberController),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 110.0),
                          child: RoundedButton(
                              color: const Color(0xFF1A57CE),
                              title: 'Save',
                              onPressed: () async {
                                await _firestore
                                    .collection('users')
                                    .doc(loggedInUser?.uid)
                                    .update({
                                  'first_name': firstNameController.text,
                                  'last_name': lastNameController.text,
                                  'email': emailController.text,
                                  'profession': professionController.text,
                                  'phone_number': phoneNumberController.text
                                }).then((value) => Navigator.of(context)
                                        .pushNamed('/profile'));
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

  Container buildProfileImageContainer(
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
              image: profileImage == null
                  ? NetworkImage(data['image_link'])
                  : profileImage != null
                      ? FileImage(profileImage!)
                      : const AssetImage('assets/images/avatar'
                          '.png') as ImageProvider)),
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
              width: 2,
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

  Future getProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => profileImage = imageTemporary);
    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }

    uploadImage();
    return FileImage(profileImage!);
  }

  Future uploadImage() async {
    if (profileImage == null) return;

    final imageName = basename(profileImage!.path);
    final destination = 'candidate_profile_images/$imageName';

    task = FirebaseStorageApi.uploadFile(destination, profileImage!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    final imageUrl = urlDownload.toString();

    await _firestore
        .collection('users')
        .doc(loggedInUser?.uid)
        .update({'image_link': imageUrl});

    print('Download-Link: $imageUrl');
  }

  _buildTextField(
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
}
