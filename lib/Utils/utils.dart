import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static const String supabaseUrl = 'https://vakxwprknaxjfqiservq.supabase.co';
  static const String publicAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZha3h3cHJrbmF4amZxaXNlcnZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODU5NzQxMTEsImV4cCI6MjAwMTU1MDExMX0.MBYwPdun3ORCQaOlMHoZC6tseCPe80FlZBJ5v_nzpeM';

  static showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF818181),
      textColor: AppColors.white,
    );
  }

  static navigateTo(BuildContext context, Widget page, {bool replace = false}) {
    if (replace) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => page));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

class AppColors {
  static const primaryColor = Color(0xFFdb0606);
  static const white = Color(0xFFFFFFFF);
}