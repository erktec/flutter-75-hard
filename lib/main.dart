import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/Utils/utils.dart';
import 'package:seventy_five_hard/screens/signup_screen.dart';
import 'package:seventy_five_hard/widgets/providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Utils.supabaseUrl,
    anonKey: Utils.publicAnonKey,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: '75Hard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: const SignUpScreen(),
      ),
    );
  }
}
