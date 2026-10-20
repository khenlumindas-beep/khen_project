import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/report_form_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String home = '/home';
  static const String report = '/report';

  static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
        login: (_) => const LoginScreen(),
        home: (_) => const DashboardScreen(),
        report: (_) => const ReportFormScreen(),
      };
}
