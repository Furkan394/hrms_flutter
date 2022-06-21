import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/bottom_navigation_bar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hrms/widgets/build_header.dart';
import 'package:hrms/widgets/white_menu_box.dart';
import 'package:hrms/utils/services/auth_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool switchValue1 = true;

  onChangeFunction1(bool newValue1) {
    setState(() {
      switchValue1 = newValue1;
    });
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
          child: ListView(
            children: [
              BuildHeader('Settings', '/profile'),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                  children: [
                    Container(
                      //height: 113,
                      color: Colors.white,
                      child: Column(
                        children: [
                          SettingsMenuBox(
                            onTap: () {
                              Navigator.pushNamed(context, '/account');
                            },
                            title: 'Account',
                            icon: const Icon(
                              FeatherIcons.user,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 27.0),
                            child: kStraightLine,
                          ),
                          SettingsMenuBox(
                            onTap: () {
                              Navigator.pushNamed(context, '/change_password');
                            },
                            title: 'Change Password',
                            icon: const Icon(
                              FeatherIcons.lock,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SettingsMenuBox(
                            onTap: () {
                              Navigator.pushNamed(context, '/cover_letter');
                            },
                            title: 'Cover Letter',
                            icon: const Icon(
                              Icons.mail_outline_rounded,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 27.0),
                            child: kStraightLine,
                          ),
                          SettingsMenuBox(
                            onTap: () {
                              Navigator.pushNamed(context, '/resume');
                            },
                            title: 'Resume',
                            icon: const Icon(
                              FeatherIcons.fileText,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildNotification(switchValue1, onChangeFunction1),
                    const SizedBox(height: 3),
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
                    const SizedBox(height: 22),
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
                    const SizedBox(height: 20),
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

Widget _buildNotification(bool switchValue, Function onChangeMethod) {
  return Container(
    color: Colors.white,
    child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 27),
        title: Text(
          'Notifications',
          style: kNunitoRegular.copyWith(fontSize: 16),
        ),
        leading: const Icon(
          FeatherIcons.bell,
          color: Colors.black,
        ),
        trailing: CupertinoSwitch(
          onChanged: (newValue) {
            onChangeMethod(newValue);
          },
          value: switchValue,
          activeColor: const Color(0xFF5160EB),
          thumbColor: Colors.white,
          trackColor: const Color(0xFFADADAD),
        )),
  );
}
