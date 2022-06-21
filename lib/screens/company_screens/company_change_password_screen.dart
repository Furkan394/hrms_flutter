import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/build_header.dart';

class CompanyChangePasswordScreen extends StatelessWidget {
  const CompanyChangePasswordScreen({Key? key}) : super(key: key);

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
                BuildHeader('Change Password', '/company_settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
