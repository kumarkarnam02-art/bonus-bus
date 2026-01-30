import 'package:flutter/material.dart';
import './login.dart';

void main() {
  runApp(const EVApp());
}

class EVApp extends StatelessWidget {
  const EVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV Move',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C853),
        ),
        fontFamily: 'Roboto',
      ),

      home: const LoginPage(),
    );
  }
}
