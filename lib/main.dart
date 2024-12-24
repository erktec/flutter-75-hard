// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb; // Correct platform check for web
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';
import 'package:seventy_five_hard/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:seventy_five_hard/services/notifications_service.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:seventy_five_hard/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Debugging Supabase initialization
  try {
    print("Initializing Supabase...");
    await Supabase.initialize(
      url: Utils.supabaseUrl, // Ensure these values are correct
      anonKey: Utils.publicAnonKey,
    );
    print("Supabase initialized successfully.");
  } catch (e, stack) {
    print("Error initializing Supabase: $e\n$stack");
  }

  // Notifications and alarm services initialization
  try {
    print("Initializing Notification Service...");
    NotificationService().initNotification();
    NotificationService().scheduleNotification();
    print("Notification Service initialized successfully.");

    // Only initialize Android Alarm Manager on non-web platforms
    if (!kIsWeb) {
      print("Initializing Android Alarm Manager...");
      await AndroidAlarmManager.initialize();
      await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        1100,
        Utils.saveProgress,
        startAt: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          Utils.time['hour'],
          Utils.time['minute'] - 1,
        ),
        exact: true,
        wakeup: true,
      );
      print("Android Alarm Manager initialized successfully.");
    } else {
      print("Skipping Android Alarm Manager on web.");
    }
  } catch (e, stack) {
    print("Error initializing notifications or alarms: $e\n$stack");
  }

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return state_provider.MultiProvider(
      providers: [
        state_provider.ChangeNotifierProvider(create: (_) => UserProvider()),
        state_provider.ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: MaterialApp(
        title: '75Hard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: const SplashScreen(), // Ensure SplashScreen works correctly
      ),
    );
  }
}
