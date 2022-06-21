import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hrms/constants.dart';
import 'package:hrms/widgets/bottom_navigation_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const MyBottomNavigationBar(),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: kMainBackgroundColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(27, 65, 27, 5),
                child: Container(
                  decoration: kMenuTopNameColor.copyWith(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 361,
                  height: 27,
                  child: Center(
                    child: Text(
                      'Notifications',
                      style: kNunitoSemiBold.copyWith(
                          fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 27),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0x95ADADAD),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 140.0),
                child: Icon(
                  FeatherIcons.bellOff,
                  size: 90,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('No notifications here',
                    style: kNunito500.copyWith(fontSize: 25)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
