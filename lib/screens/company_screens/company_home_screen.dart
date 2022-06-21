import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/white_menu_box.dart';

class CompanyHomeScreen extends StatelessWidget {
  const CompanyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: kMainBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 36.0),
            child: ListView(
              children: [
                Image.asset(
                  'assets/images/career_wind.png',
                  width: 114,
                  height: 76,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      kAppName,
                      const SizedBox(height: 60),
                      MenuBox(
                          route: '/create_job',
                          title: 'Create a Job Posting',
                          icon: Icons.add_circle_outline_rounded),
                      const SizedBox(height: 10),
                      MenuBox(
                          route: '/company_job_postings',
                          title: 'My Job Postings',
                          icon: CupertinoIcons.archivebox),
                      const SizedBox(height: 10),
                      MenuBox(
                          route: '/create_job', //TODO: candidates list
                          title: 'Candidate List',
                          icon: FeatherIcons.user),
                      const SizedBox(height: 10),
                      MenuBox(
                          route: '/create_job', //TODO: resume list
                          title: 'Resume List',
                          icon: FeatherIcons.fileText),
                      const SizedBox(height: 100),
                      MenuBox(
                          route: '/company_settings',
                          title: 'Settings',
                          icon: FeatherIcons.settings),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuBox extends StatelessWidget {
  final String route;
  final String title;
  final IconData icon;

  MenuBox({required this.route, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 7,
            offset: const Offset(0, 2),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: SettingsMenuBox(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        title: title,
        icon: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }
}
