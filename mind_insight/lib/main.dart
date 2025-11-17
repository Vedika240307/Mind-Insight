import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'services/firestore_initializer.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔥 Auto-create all required Firestore collections
  await FirestoreInitializer.initialize();

  runApp(const MindInsightApp());
}

class MindInsightApp extends StatelessWidget {
  const MindInsightApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color appPink = Color(0xFFE91E63);

    return MaterialApp(
      title: 'Mind Insight',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: appPink,
          secondary: appPink,
        ),

        scaffoldBackgroundColor: const Color(0xFFFFF0F6),

        appBarTheme: const AppBarTheme(
          backgroundColor: appPink,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      home: const LoginScreen(),

      routes: {'/home': (context) => const HomeScreen()},
    );
  }
}
