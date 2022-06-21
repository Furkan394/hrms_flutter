import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/utils/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:hrms/widgets/white_menu_box.dart';

class CompanySettingsScreen extends StatelessWidget {
  const CompanySettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: kMainBackgroundColor,
          child: ListView(
            children: [
              BuildHeader('Settings', '/company_home'),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                  children: [
                    Column(children: [
                      Container(
                        color: Colors.white,
                        child: SettingsMenuBox(
                          onTap: () {
                            Navigator.pushNamed(context, '/company_account');
                          },
                          title: 'Account',
                          icon: const Icon(
                            FeatherIcons.user,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        child: SettingsMenuBox(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/company_change_password');
                          },
                          title: 'Change Password',
                          icon: const Icon(
                            FeatherIcons.lock,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        child: SettingsMenuBox(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/company_description');
                          },
                          title: 'Company Description',
                          icon: const Icon(
                            Icons.description_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        child: SettingsMenuBox(
                          onTap: () {},
                          title: 'Help',
                          icon: const Icon(
                            Icons.help_outline_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 70),
                      Container(
                        color: Colors.white,
                        child: ListTile(
                          onTap: () {
                            context.read<AuthService>().signOut(context);
                          },
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 27),
                          title: Text(
                            'Sign Out',
                            style: kNunitoRegular.copyWith(
                                fontSize: 16, color: const Color(0xFF5160EB)),
                          ),
                          leading: const Icon(
                            FeatherIcons.logOut,
                            color: Color(0xFF5160EB),
                          ),
                        ),
                      ),
                      const SizedBox(height: 90),
                      Image.asset(
                        'assets/images/career_wind.png',
                        width: 75,
                        height: 45,
                      ),
                      const Text(
                        'v1.0.0',
                        style: kNunitoRegular,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Copyright © 2022, Career Wind, All Rights Reserved.',
                        style: kNunitoRegular,
                      )
                    ])
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
