import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';

class RoundedButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const RoundedButton(
      {required this.color, required this.title, required this.onPressed});

  final Color color;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 3.0,
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child:
              Text(title, style: kNunitoSemiBold.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}
