import 'package:flutter/material.dart';

import 'constants/app_constants.dart';
import 'routes/app_routes.dart';

class SmartTrackApp extends StatelessWidget {
  const SmartTrackApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      );
}
