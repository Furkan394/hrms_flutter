import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hrms/screens/candidate_screens/home_screen.dart';
import 'package:hrms/screens/company_screens/company_home_screen.dart';
import 'package:hrms/utils/services/auth_service.dart';
import 'package:hrms/widgets/log_reg_textfield.dart';
import 'package:hrms/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String role = '';

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    setState(() {
      role = snap['role'];
    });

    if (role == 'candidate') {
      navigateNext(const HomeScreen());
    } else if (role == 'company') {
      navigateNext(const CompanyHomeScreen());
    }
  }

  void navigateNext(Widget route) {
    Timer(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => route));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kLoginRegisterBackgroundColor,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  buildHero(),
                  buildWelcomeText(),
                  const SizedBox(height: 43),
                  LogRegTextField(
                      controller: emailController,
                      title: 'E-mail',
                      hintText: 'Enter '
                          'your e-mail',
                      icon: const Icon(
                        FeatherIcons.mail,
                        color: Colors.black,
                      ),
                      text: 'email'),
                  const SizedBox(height: 10),
                  PasswordTextField(
                      controller: passwordController,
                      title: 'Password',
                      hintText: 'Enter your '
                          'password',
                      icon: const Icon(
                        FeatherIcons.lock,
                        color: Colors.black,
                      ),
                      text: 'password'),
                  buildForgotPassword(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(85, 0, 85, 0),
                    child: RoundedButton(
                        color: const Color(0xFF1A57CE),
                        onPressed: () async {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          if (_formKey.currentState!.validate()) {
                            try {
                              await context
                                  .read<AuthService>()
                                  .login(email, password);
                              _checkRole();
                            } catch (e) {
                              print('ERROR =>>>  $e');
                            }
                          }
                        },
                        title: 'Log '
                            'In'),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Sign Up',
                        style: kNunitoSemiBold.copyWith(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 55),
          child: TextButton(
            onPressed: () {
              //TODO: forgot password onPressed
            },
            child: Text('Forgot Password?',
                style: kNunitoRegular.copyWith(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Column buildWelcomeText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        kAppName,
        const SizedBox(height: 40),
        Text(
          'Welcome to Career Wind!',
          style: kNunitoSemiBold.copyWith(fontSize: 22),
        ),
      ],
    );
  }

  Hero buildHero() {
    return Hero(
      tag: 'logo',
      child: Image.asset(
        'assets/images/career_wind.png',
        width: 163,
        height: 106,
      ),
    );
  }
}
