// ignore_for_file: use_build_context_synchronously

import 'dart:developer'; // Import this for the `log` method.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:seventy_five_hard/screens/home_screen.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/models/user_model.dart';
import 'package:seventy_five_hard/screens/signup_screen.dart';
import 'package:seventy_five_hard/services/supabase_services.dart';
import 'package:seventy_five_hard/widgets/input_field.dart';
import 'package:seventy_five_hard/widgets/primary_button.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  SupabaseServices supabaseServices = SupabaseServices.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Landscape.png', width: 400, height: 200),
            InputField(
              controller: emailController,
              label: 'Email',
              isPasswordField: false,
            ),
            const SizedBox(height: 16),
            InputField(
              controller: passwordController,
              label: 'Password',
              isPasswordField: true,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              isLoading: isLoading,
              onPressed: login,
              title: 'SignIn',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                InkWell(
                  onTap: () => Utils.navigateTo(context, const SignUpScreen()),
                  child: const Text(
                    "SignUp",
                    style:
                        TextStyle(color: AppColors.primaryColor, fontSize: 16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Utils.showToast('Please fill all the fields');
      return;
    }

    UserProvider userProvider = Provider.of(context, listen: false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool defaultPenalty = prefs.getBool('defaultPenalty') ?? true;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await supabaseServices.login(
        email: emailController.text,
        password: passwordController.text,
      );

      log('Login Response: $response'); // Log the response for debugging

      if (response.isNotEmpty && response.containsKey("username")) {
        userProvider.setUser(
          User(
            username: response["username"],
            email: response["email"],
            imageUrl: response["imageUrl"],
          ),
        );
        userProvider.setDefaultPenalty(defaultPenalty);

        await _setProgress();
        Utils.showToast('Login successful!');
        Utils.navigateTo(context, const HomeScreen(), replace: true);

        emailController.clear();
        passwordController.clear();
      } else {
        Utils.showToast('Invalid email or password. Please try again.');
      }
    } catch (e) {
      Utils.showToast('Error during login: $e');
      log('Error: $e'); // Log any error during login
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _setProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int currentDay = prefs.getInt('currentDay') ?? 1;
    final double diet = prefs.getDouble('diet') ?? 0.0;
    final double workout1 = prefs.getDouble('workout1') ?? 0.0;
    final double workout2 = prefs.getDouble('workout2') ?? 0.0;
    final double picture = prefs.getDouble('picture') ?? 0.0;
    final double water = prefs.getDouble('water') ?? 0.0;
    final double reading = prefs.getDouble('reading') ?? 0.0;
    await prefs.setBool('75Hard-isLoggedIn', true);

    Provider.of<ProgressProvider>(context, listen: false).setProgress(
      day: currentDay,
      diet: diet,
      reading: reading,
      picture: picture,
      workout1: workout1,
      workout2: workout2,
      water: water,
    );
  }
}
