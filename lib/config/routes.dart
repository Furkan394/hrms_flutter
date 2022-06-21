import 'package:flutter/material.dart';
import 'package:hrms/screens/register_screen.dart';
import 'package:hrms/screens/candidate_screens/home_screen.dart';
import 'package:hrms/screens/candidate_screens/saved_screen.dart';
import 'package:hrms/screens/candidate_screens/notifications_screen.dart';
import 'package:hrms/screens/candidate_screens/profile_screen.dart';
import 'package:hrms/screens/candidate_screens/settings_screens/settings_screen.dart';
import 'package:hrms/screens/candidate_screens/settings_screens'
    '/account_screen.dart';
import 'package:hrms/screens/candidate_screens/settings_screens'
    '/change_password_screen.dart';
import 'package:hrms/screens/candidate_screens/settings_screens'
    '/cover_letter_screen.dart';
import 'package:hrms/screens/candidate_screens/settings_screens/resume_screen'
    '.dart';
import 'package:hrms/screens/company_screens/company_home_screen.dart';
import 'package:hrms/screens/company_screens/create_job_screen.dart';
import 'package:hrms/screens/company_screens/company_settings_screen.dart';
import 'package:hrms/screens/company_screens/company_change_password_screen.dart';
import 'package:hrms/screens/company_screens/company_description_screen.dart';
import 'package:hrms/screens/company_screens/company_account_screen.dart';
import 'package:hrms/screens/company_screens/company_job_postings.dart';

var routes = <String, WidgetBuilder>{
  '/register': (context) => const RegisterScreen(),
  '/home': (context) => const HomeScreen(),
  '/saved': (context) => const SavedScreen(),
  '/notifications': (context) => const NotificationScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/account': (context) => const AccountScreen(),
  '/change_password': (context) => const ChangePasswordScreen(),
  '/cover_letter': (context) => const CoverLetterScreen(),
  '/resume': (context) => const ResumeScreen(),
  '/company_home': (context) => const CompanyHomeScreen(),
  '/create_job': (context) => const CreateJobScreen(),
  '/company_settings': (context) => const CompanySettingsScreen(),
  '/company_change_password': (context) => const CompanyChangePasswordScreen(),
  '/company_description': (context) => const CompanyDescriptionScreen(),
  '/company_account': (context) => const CompanyAccountScreen(),
  '/company_job_postings': (context) => const CompanyJobPostings(),
};
