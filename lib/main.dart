import 'package:cursproject/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(const CursApp());

}

class CursApp extends StatelessWidget {
  const CursApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(


      home: const AuthPage(),
    );
  }
}
