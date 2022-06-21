import 'package:flutter/material.dart';
import 'package:hrms/constants.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hrms/utils/services/auth_service.dart';
import 'package:hrms/widgets/log_reg_textfield.dart';
import 'package:hrms/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController webAddressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: kLoginRegisterBackgroundColor,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/career_wind.png',
                    width: 101,
                    height: 66,
                  ),
                ),
                DefaultTabController(
                  length: 2,
                  child: Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TabBar(
                            labelColor: const Color(0xFF5545B7),
                            unselectedLabelColor: Colors.black,
                            labelStyle: kNunitoRegular.copyWith(fontSize: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 45),
                            indicatorColor: const Color(0xFF5545B7),
                            indicatorWeight: 3,
                            tabs: const [
                              Tab(
                                icon: Icon(
                                  FeatherIcons.user,
                                ),
                                text: 'Individual',
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.business,
                                ),
                                text: 'Company',
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Form(
                              key: _formKey,
                              child: TabBarView(
                                children: [
                                  _buildIndividualForm(),
                                  _buildCompanyForm(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  _buildIndividualForm() {
    return ListView(
      children: [
        LogRegTextField(
            controller: firstNameController,
            title: 'First name',
            hintText: 'Enter your first name',
            icon: const Icon(
              FeatherIcons.user,
              color: Colors.black,
            ),
            text: 'firstname'),
        const SizedBox(height: 10),
        LogRegTextField(
            controller: lastNameController,
            title: 'Last name',
            hintText: 'Enter your last name',
            icon: const Icon(FeatherIcons.user, color: Colors.black),
            text: 'lastname'),
        const SizedBox(height: 10),
        LogRegTextField(
            controller: emailController,
            title: 'E-mail',
            hintText: 'Enter your e-mail',
            icon: const Icon(FeatherIcons.mail, color: Colors.black),
            text: 'email'),
        const SizedBox(height: 10),
        PasswordTextField(
          controller: passwordController,
          title: 'Password',
          hintText: 'Enter your password',
          icon: const Icon(FeatherIcons.lock, color: Colors.black),
          text: 'password',
        ),
        _signUpButtonForIndividual(),
        _backToLoginText(context)
      ],
    );
  }

  _buildCompanyForm() {
    return ListView(
      children: [
        LogRegTextField(
            controller: companyNameController,
            title: 'Company name',
            hintText: 'Enter your company name',
            icon: const Icon(
              Icons.business,
              color: Colors.black,
            ),
            text: 'company name'),
        const SizedBox(height: 10),
        LogRegTextField(
            controller: webAddressController,
            title: 'Web address',
            hintText: 'Enter your web address',
            icon: const Icon(Icons.web, color: Colors.black),
            text: 'web address'),
        const SizedBox(height: 10),
        LogRegTextField(
            controller: emailController,
            title: 'E-mail',
            hintText: 'Enter your e-mail',
            icon: const Icon(FeatherIcons.mail, color: Colors.black),
            text: 'email'),
        const SizedBox(height: 10),
        PasswordTextField(
          controller: passwordController,
          title: 'Password',
          hintText: 'Enter your password',
          icon: const Icon(FeatherIcons.lock, color: Colors.black),
          text: 'password',
        ),
        _signUpButtonForCompany(),
        _backToLoginText(context),
      ],
    );
  }

  _signUpButtonForIndividual() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(85, 5, 85, 0),
      child: RoundedButton(
          color: const Color(0xFF1A57CE),
          title: 'Sign up',
          onPressed: () async {
            String firstName = firstNameController.text;
            String lastName = lastNameController.text;
            String email = emailController.text;
            String password = passwordController.text;

            if (_formKey.currentState!.validate()) {
              try {
                await context
                    .read<AuthService>()
                    .signUpForIndividual(firstName, lastName, email, password)
                    .then((value) => Navigator.pushNamed(context, '/home'));
              } catch (e) {
                print('ERROR =>>>  $e');
              }
            }
          }),
    );
  }

  _signUpButtonForCompany() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(85, 5, 85, 0),
      child: RoundedButton(
          color: const Color(0xFF1A57CE),
          title: 'Sign up',
          onPressed: () async {
            String companyName = companyNameController.text;
            String webAddress = webAddressController.text;
            String email = emailController.text;
            String password = passwordController.text;

            if (_formKey.currentState!.validate()) {
              try {
                await context
                    .read<AuthService>()
                    .signUpForCompany(companyName, webAddress, email, password)
                    .then((value) =>
                        Navigator.pushNamed(context, '/company_home'));
              } catch (e) {
                print('ERROR =>>>  $e');
              }
            }
          }),
    );
  }
}

_backToLoginText(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.pushNamed(context, '/');
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Have an account? ' ' ',
            style: kNunitoSemiBold.copyWith(color: Colors.white)),
        Text('Log In',
            style: kNunitoSemiBold.copyWith(color: const Color(0xFF1A57CE))),
      ],
    ),
  );
}
