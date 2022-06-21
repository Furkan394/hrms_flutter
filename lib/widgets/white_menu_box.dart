import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';

class SettingsMenuBox extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback onTap;

  SettingsMenuBox(
      {required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 27),
      title: Text(
        title,
        style: kNunitoRegular.copyWith(fontSize: 16),
      ),
      leading: icon,
      trailing:
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black54),
    );
  }
}
