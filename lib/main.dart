// Nama: Jamilatul Amalia
// NIM: 2415051107

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'models/course_state.dart';
import 'pages/login_page.dart';
import 'repositories/course_repository.dart';
import 'services/auth_service.dart';
import 'services/course_supabase_service.dart';
import 'widgets/responsive_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  final repository = CourseRepository(CourseSupabaseService());

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseState(repository: repository)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AuthService.instance.isLoggedIn;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Data Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? const ResponsiveShell() : const LoginPage(),
    );
  }
}