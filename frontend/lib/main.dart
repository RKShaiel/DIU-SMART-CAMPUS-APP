import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart'; // 🔥 MUST import this

import 'providers/theme_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 THIS IS THE FIX
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('settingsBox');
  await Hive.openBox('profileBox');

  final themeProvider = ThemeProvider();
  themeProvider.loadFromHive();

  final profileProvider = ProfileProvider();
  profileProvider.loadFromHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => profileProvider),
      ],
      child: const DIUSmartCampusApp(),
    ),
  );
}

class DIUSmartCampusApp extends StatelessWidget {
  const DIUSmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DIU Smart Campus',
      themeMode: themeProvider.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}