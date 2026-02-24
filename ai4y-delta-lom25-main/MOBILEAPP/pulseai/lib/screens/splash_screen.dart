import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import '../core/theme/app_theme.dart';
import '../core/constants/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    debugPrint('SplashScreen: initState appelé');
    Timer(const Duration(milliseconds: 3500), () {
      debugPrint('SplashScreen: Timer terminé, navigation vers onboarding');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    AppAssets.logo,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) {
                      debugPrint('SplashScreen: Erreur de chargement du logo');
                      return const Icon(Icons.health_and_safety, size: 80, color: AppTheme.primaryBlue);
                    },
                  ),
                ),
              )
              .animate()
              .scale(duration: 600.ms, curve: Curves.easeOutBack)
              .then(delay: 200.ms)
              .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.5)),
              
              const SizedBox(height: 40),
              
              // Logo only, no text
            ],
          ),
        ),
      ),
    );
  }
}
