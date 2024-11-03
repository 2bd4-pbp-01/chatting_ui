import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chatting_ui/login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 300),
              // First image
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              // Spacing between images
              const SizedBox(height: 250),
            
              // Second image
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  'assets/from_kel1.png',
                  fit: BoxFit.contain,
                ),
              ),
              // This will push everything up by taking remaining space
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}