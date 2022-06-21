import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:hrms/widgets/bottom_navigation_bar.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

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
            child: Column(
              children: [
                BuildHeader('Change Password', '/settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
