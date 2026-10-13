import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
        login: (_) => const LoginScreen(),
        home: (_) => const DashboardScreen(),
      };
}
