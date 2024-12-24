// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:seventy_five_hard/screens/home_screen.dart';
import 'package:seventy_five_hard/screens/login_screen.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirect();
    });
  }

  Future<void> _redirect() async {
    final session = supabase.auth.currentSession;

    if (session != null) {
      // User is authenticated, set progress and navigate to HomeScreen
      await _setProgress();
      if (mounted) {
        Utils.navigateTo(context, const HomeScreen(), replace: true);
      }
    } else {
      // No active session, navigate to LoginScreen
      if (mounted) {
        Utils.navigateTo(context, const LoginScreen(), replace: true);
      }
    }
  }

  Future<void> _setProgress() async {
    try {
      final preferences = await Utils.getPreferences();
      state_provider.Provider.of<ProgressProvider>(context, listen: false)
          .setProgress(
        day: preferences['currentDay'],
        diet: preferences['diet'],
        reading: preferences['reading'],
        picture: preferences['picture'],
        workout1: preferences['workout1'],
        workout2: preferences['workout2'],
        water: preferences['water'],
      );
    } catch (e) {
      debugPrint('Error setting progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Square.png', height: 300),
            const SizedBox(height: 100),
            const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
