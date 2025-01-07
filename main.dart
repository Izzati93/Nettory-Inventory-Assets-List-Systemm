import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nettory_app/firebase_options.dart';
import 'pages/welcome.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/dashboard.dart';
import 'pages/asset.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Ensure Firebase is initialized only if no app exists
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    // Initialize Firebase Analytics instance after Firebase initialization
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    // Log an event when the app starts
    await analytics.logEvent(
      name: 'app_start',
      parameters: {
        'timestamp': DateTime.now().toString(),
      },
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'inter',
        useMaterial3: true,
      ),
      home: const Welcome(),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/dashboard': (context) => const Dashboard(),
        '/asset': (context) => Asset(),
      },
    );
  }
}
