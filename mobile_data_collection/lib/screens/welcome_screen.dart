import 'dart:async';
import 'login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_data_collection/screens/home_screen/home_screen.dart';
import 'package:mobile_data_collection/service/auth_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 750),
      ),
    );
  }

  void navigateToHome(String username, String email, String initial) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(username, email, initial),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 750),
      ),
    );
  }

  Future<void> checkLoginStatus() async {
    // Afficher l'écran de bienvenue pendant au moins 2 secondes
    await Future.delayed(const Duration(seconds: 2));
    
    // Vérifier si l'utilisateur est déjà connecté
    final isLoggedIn = await AuthService.isLoggedIn();
    
    if (isLoggedIn) {
      // Récupérer les informations utilisateur stockées
      final userInfo = await AuthService.getUserInfo();
      
      if (userInfo.isNotEmpty && mounted) {
        // Naviguer vers l'écran d'accueil avec les informations utilisateur
        navigateToHome(
          userInfo['username']!,
          userInfo['email']!,
          userInfo['initial']!
        );
      } else if (mounted) {
        // Si les informations utilisateur sont manquantes, rediriger vers la connexion
        navigateToLogin();
      }
    } else if (mounted) {
      // Si non connecté, rediriger vers l'écran de connexion
      navigateToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            bottom: 0.3 * screenSize.height,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset('assets/images/logoT.png', width: 170),
                Transform.translate(
                  offset: const Offset(0, -50),
                  child: const Text(
                    'TerangaCollecte',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFC3AD65),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
