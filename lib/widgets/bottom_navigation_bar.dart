import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/screens/candidate_screens/home_screen.dart';
import 'package:hrms/screens/candidate_screens/notifications_screen.dart';
import 'package:hrms/screens/candidate_screens/profile_screen.dart';
import 'package:hrms/screens/candidate_screens/saved_screen.dart';
import 'package:iconly/iconly.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return buildBottomNavigationBar(context);
  }

  Container buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 77,
      decoration: const BoxDecoration(
        color: Color(0xFF439DE2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavigationItem(context, '/home', IconlyLight.home, 'Home'),
            buildNavigationItem(context, '/saved', FeatherIcons.heart, 'Saved'),
            buildNavigationItem(
                context, '/notifications', FeatherIcons.bell, 'Notifications'),
            buildNavigationItem(
                context,
                '/profile',
                FeatherIcons.user,
                'Profil'
                    'e')
          ],
        ),
      ),
    );
  }

  Widget buildNavigationItem(
      BuildContext context, String route, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.pushReplacementNamed(context, route);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 34,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: kNunito500.copyWith(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
