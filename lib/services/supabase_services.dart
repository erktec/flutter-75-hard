// ignore_for_file: unused_field

import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  Session? _session;
  static SupabaseServices? _instance;

  SupabaseServices._();

  static SupabaseServices get instance {
    _instance ??= SupabaseServices._();
    return _instance!;
  }

  final supabase = Supabase.instance.client;

  Future<String> signup(
      {required String email,
      required String password,
      required String username}) async {
    String response = '';
    try {
      final AuthResponse authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      final Session? session = authResponse.session;
      final User? user = authResponse.user;

      if (session != null) {
        _session = session;
      }

      log('user: ${user?.email}');
      log('user metadata: ${user?.userMetadata}');
      await supabase.from('users').insert({
        'username': user?.userMetadata?['username'],
        'email': user?.email,
        'image_url':
            'https://api.dicebear.com/6.x/bottts/svg?seed=${user?.userMetadata?['username']}&backgroundColor=FFFFFF'
      });

      response = "success";
    } on PostgrestException catch (e) {
      response = e.message.toString();
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    final Map<String, dynamic> userData = {};
    try {
      AuthResponse authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _session = authResponse.session;
      User? user = authResponse.user;

      if (user == null) {
        log('Login failed: User is null');
        return userData;
      }

      final imageUrl = await getUserAvatar(user.email!);
      userData["username"] = user.userMetadata?['username'] ?? 'Unknown';
      userData["email"] = user.email;
      userData["imageUrl"] = imageUrl;

      log('Login successful: $userData');
    } catch (e) {
      log('Login error: $e');
    }

    return userData;
  }

  Future<String> getUserAvatar(String email) async {
    try {
      final data =
          await supabase.from('users').select('image_url').eq('email', email);
      if (data.isNotEmpty && data[0]["image_url"] != null) {
        return data[0]["image_url"];
      }
    } catch (e) {
      log('Error fetching avatar: $e');
    }
    return 'https://via.placeholder.com/150';
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
