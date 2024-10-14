import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget{
@override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<LoginScreen> {

  Widget topWidget(double screenWidth) {
    return Transform.rotate(
      angle: -35 * math.pi / 180,
      child: Container(
        width: 1.2*screenWidth,
        height: 1 * screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: const LinearGradient(
            begin: Alignment(-0.2, -0.8),
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 246, 236, 206),
              Color(0xFFC3AD65)
            ],
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false, //permettre de fixer le contenu
      body: Stack(
        children: [
          Positioned(
            top: -160,
            left: -30,
            child: topWidget(screenSize.width),
          ),
          // Positioned(
          //   top: 120,
          //   left: 15,
            
          //   child: Column(
          //     children: [
          //       Transform.translate(
          //         offset: const Offset(0, -50),
          //         child: const Text(
          //           'Se connecter',
          //           style: TextStyle(
          //             fontSize: 29,
          //             color: Color(0xFFC3AD65),
          //             fontFamily: 'Roboto-Regular',
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Positioned(
            bottom: 130,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Champ email
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Adresse email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF8c6023), // Couleur de la bordure quand le champ est en focus
                        ),
                      ),
                       // Style du label lorsqu'il est en focus
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFF8c6023), // Couleur du label en focus
                      )
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Champ mot de passe
                  const TextField(
                    
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF8c6023), // Couleur de la bordure quand le champ est en focus
                        ),
                      ),
                      // Style du label lorsqu'il est en focus
                      floatingLabelStyle: TextStyle(
                        color: Color(0xFF8c6023), // Couleur du label en focus
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Aligne le texte à droite
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Logique de "Mot de passe oublié" ici
                        },
                        child: const Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(
                            color: Color(0xFF8c6023), // Vous pouvez personnaliser la couleur
                            decoration: TextDecoration.none, // Souligne le texte
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Logique de connexion à implémenter ici
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: Color(0xFFC3AD65), // Couleur du texte
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Ajuste les marges internes
                      textStyle: const TextStyle(
                        fontSize: 18, // Taille du texte
                        fontWeight: FontWeight.bold, // Style du texte
                      ),
                    ),
                    child: const Text('Connexion'),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child:  Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text('Vous n\'avez pas de compte ?'),
                      Expanded(
                        child:  Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Logique de connexion à implémenter ici
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFC3AD65), 
                      backgroundColor: Colors.white, // Couleur du texte
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Ajuste les marges internes
                      textStyle: const TextStyle(
                        fontSize: 18, // Taille du texte
                        fontWeight: FontWeight.bold, // Style du texte
                      ),
                      side: const BorderSide(
                        color: Color(0xFFc3AD65),
                        width: 2,
                      ),
                      
                    ),
                    child: const Text('S\'inscrire'),
                  ),
                ],  
              ),
            ),
          ),  
        ],
      ),
    );
  }
}