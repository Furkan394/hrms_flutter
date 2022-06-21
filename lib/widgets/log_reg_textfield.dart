import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';

class LogRegTextField extends StatelessWidget {
  late String title;
  late String hintText;
  Icon icon;
  TextEditingController controller;
  late String text;

  LogRegTextField(
      {required this.title,
      required this.hintText,
      required this.icon,
      required this.controller,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 61.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: kNunito500),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              validator: validator,
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: kTextFieldDecoration.copyWith(
                  hintText: hintText, prefixIcon: icon),
            ),
          ),
        ],
      ),
    );
  }

  String? validator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $text';
    }
    return null;
  }
}

class PasswordTextField extends StatefulWidget {
  late String title;
  late String hintText;
  late Icon icon;
  late TextEditingController controller;
  late String text;

  PasswordTextField({
    required this.title,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.text,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 61.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: kNunito500),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              validator: validator,
              controller: widget.controller,
              obscureText: !isVisible,
              keyboardType: TextInputType.emailAddress,
              decoration: kTextFieldDecoration.copyWith(
                  hintText: widget.hintText,
                  prefixIcon: widget.icon,
                  suffixIcon: buildIconButton()),
            ),
          ),
        ],
      ),
    );
  }

  IconButton buildIconButton() {
    return IconButton(
        onPressed: () => setState(() {
              isVisible = !isVisible;
            }),
        icon: isVisible
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility));
  }

  String? validator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your ${widget.text}';
    }
    return null;
  }
}
