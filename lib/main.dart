import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hrms/config/routes.dart';
import 'package:hrms/screens/login_screen.dart';
import 'package:hrms/utils/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const HRMS());
}

class HRMS extends StatelessWidget {
  const HRMS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        routes: routes,
        home: const LoginScreen(),
      ),
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<User?>();
//
//     // if (user != null) {
//     //   return const LoginScreen();
//     // }
//     return const LoginScreen();
//   }
// }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
