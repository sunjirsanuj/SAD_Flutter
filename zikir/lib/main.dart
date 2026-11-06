import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zikir_tracker/providers/auth_provider.dart';
import 'package:zikir_tracker/providers/zikir_provider.dart';
import 'package:zikir_tracker/screens/login_page.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ZikirProvider()..load(),
        ),
      ],
      child: const ZikirTrackerApp(),
    ),
  );
}

class ZikirTrackerApp extends StatelessWidget {
  const ZikirTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zikra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const LoginPage(),
    );
  }
}
