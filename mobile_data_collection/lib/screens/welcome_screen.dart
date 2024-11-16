import 'dart:async';
import 'login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
          // Appliquer une animation de fondu en utilisant FadeTransition
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration:
            const Duration(milliseconds: 750), // Durée de l'animation
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
            top: -160,
            left: -30,
            child: topWidget(screenSize.width),
          ),
          Positioned(
            bottom: 250,
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
                      fontSize: 31,
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

//définit en dehors de la classe pour pouvoir être utilisé dans login_screen
Widget topWidget(double screenWidth) {
  return Transform.rotate(
    angle: -35 * math.pi / 180,
    child: Container(
      width: 1.2 * screenWidth,
      height: 1 * screenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: const LinearGradient(
            begin: Alignment(-0.2, -0.8),
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 246, 236, 206), Color(0xFFC3AD65)],
          )),
    ),
  );
}
