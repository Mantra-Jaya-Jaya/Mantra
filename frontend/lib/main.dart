import 'package:flutter/material.dart';
import 'features/auth/signup.dart';
import 'features/landing_page/landing_page.dart';

// 1. TAMBAHKAN INI: Deklarasikan variabel secara global di luar class
final RouteObserver<Route> routeObserver = RouteObserver<Route>();

void main() {
  runApp(const MantraApp());
}

class MantraApp extends StatelessWidget {
  const MantraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 2. TAMBAHKAN INI: Daftarkan observer agar sistem navigasi Flutter mengenalinya
      navigatorObservers: [routeObserver],
      home: const LandingPage(),
    );
  }
}
