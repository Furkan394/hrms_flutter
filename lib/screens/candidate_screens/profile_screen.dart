import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:unicons/unicons.dart';
import 'package:hrms/widgets/bottom_navigation_bar.dart';
import 'package:hrms/utils/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  UploadTask? task;
  File? file;

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
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const MyBottomNavigationBar(),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: kMainBackgroundColor,
          child: ListView(
            children: [
              _buildHeader(context),
              const Divider(
                color: Color(0x95ADADAD),
                thickness: 1,
              ),
              _buildProfileField(context),
              Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: kStraightLine),
              _buildProfessionField(),
              kStraightLine,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'Cover Letter',
                    style: kNunito500.copyWith(fontSize: 17),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(17),
                height: 170,
                color: const Color(0x807000E0),
                child: FutureBuilder<DocumentSnapshot>(
                  future: getLoggedInUser(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return const Text("Document does not exist");
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Text("${data['cover_letter']}",
                          style: kNunitoRegular.copyWith(
                              fontSize: 15, color: Colors.white));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              _buildUploadButton(),
              const SizedBox(height: 3),
              buildTaskStatus(fileName),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getLoggedInUser() {
    return _firestore.collection('users').doc(loggedInUser?.uid).get();
  }

  Row buildTaskStatus(String fileName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            fileName,
            style: kNunitoRegular,
          ),
        ),
        task != null ? buildUploadStatus(task!) : Container(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'Profile',
                    style: kNunito500.copyWith(fontSize: 19),
                  ),
                ),
                Positioned(
                    right: 26,
                    child: InkWell(
                      child: const Icon(
                        UniconsLine.setting,
                        size: 27,
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/settings');
                      },
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileField(BuildContext context) {
    return FutureBuilder(
        future: getLoggedInUser(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(35, 15, 40, 15),
                    child: SizedBox(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(data['image_link']),
                      ),
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
                Center(
                    heightFactor: 4.3, //for align but interesting?
                    child: Text("${data['first_name']} ${data['last_name']}",
                        style: kNunito500.copyWith(
                            fontSize: 17, color: const Color(0xFF0314AB)))),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildProfessionField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 35),
            child: Column(
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: getLoggedInUser(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Text("${data['profession']}", style: kNunito500);
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                const SizedBox(height: 10),
                FutureBuilder<DocumentSnapshot>(
                  future: getLoggedInUser(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Text("${data['phone_number']}", style: kNunito500);
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildUploadButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(115, 22.5, 115, 0),
      child: Material(
        elevation: 3.0,
        color: const Color(0xFF005FFC),
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          onPressed: () {
            selectFile();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text('Upload Resume',
                    style: kNunito500.copyWith(color: Colors.white)),
              ),
              const Icon(
                FeatherIcons.upload,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf']);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));

    uploadFile();
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'resumes/$fileName';

    task = FirebaseStorageApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    await _firestore
        .collection('users')
        .doc(loggedInUser?.uid)
        .update({'resume_link': urlDownload});

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: kNunitoRegular,
            );
          } else {
            return Container();
          }
        },
      );
}
