import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/router/app_router.dart';
import 'package:safecar_mobile_app/shared/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'SafeCar Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
