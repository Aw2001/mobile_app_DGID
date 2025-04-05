import 'dart:async';
import 'login_screen/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    starTimer();
  }

  void loginRoute() {
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

  starTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, loginRoute);
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
