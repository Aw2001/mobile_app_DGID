import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/login_utilisateur.dart';
import 'package:mobile_data_collection/screens/forgot_password/forgot_password_screnn.dart';
import 'package:mobile_data_collection/screens/home_screen/home_screen.dart';
import 'package:mobile_data_collection/service/auth_service.dart';
import 'package:mobile_data_collection/service/storage_service.dart';
import 'package:mobile_data_collection/service/user_service.dart';
import '../../utils/constants.dart';
import '../sign_up_screen/sign_up_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/logoT.png', width: 90),
                          const SizedBox(height: 10),
                          const Text(
                            "Bienvenue",
                            style: TextStyle(fontSize: 18, color: Color(0xFFC3AD65), fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Veuillez vous connecter pour continuer',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _FormContent(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width * 0.5, size.height,
      size.width, size.height * 0.75,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  String initial = '';
  String email = '';
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = "";
  LoginUtilisateur user = LoginUtilisateur("", "");
  UserService userService = UserService();

  Future<void> loginUser(String username, String password) async {
    setState(() {
      _errorMessage = "";
    });
    
    try {
      print("Tentative de connexion...");
      // Tentative de connexion via UserService
      bool loginSuccess = await userService.login(username, password);
      print("Résultat login: $loginSuccess");
      
      if (loginSuccess) {
        try {
          // Récupérer les informations de l'utilisateur
          print("Récupération des initiales...");
          initial = await userService.retourneInitial(username);
          print("Initiales récupérées: $initial");
          
          print("Récupération de l'email...");
          email = await userService.getEmailByUsername(username);
          print("Email récupéré: $email");
          
          if (email.isEmpty) {
            print("Email vide reçu");
            setState(() {
              _errorMessage = "Impossible de récupérer les informations utilisateur";
            });
          } else {
            // Sauvegarder les informations utilisateur pour la persistance de session
            await AuthService.saveUserInfo(username, email, initial);
            
            print("Navigation vers HomeScreen");
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(username, email, initial)),
              );
            }
          }
        } catch (e) {
          print("Erreur lors de la récupération des infos: $e");
          setState(() {
            _errorMessage = "Erreur lors de la récupération des informations utilisateur";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Identifiants incorrects";
        });
      }
    } catch (e) {
      print("Erreur de connexion: $e");
      setState(() {
        _errorMessage = "Erreur de connexion au serveur";
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
             if (_errorMessage.isNotEmpty)
              Column(
                 children: [
                  Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // Espacement avec les champs
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ),
                 ] 
              ),
              
            // Champ username
            TextFormField(
              controller: _usernameController,
              onChanged: (val) {
                user.identifiant = val.trim();
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8c6023),
                  ),
                ),
                floatingLabelStyle: TextStyle(
                  color: Color(0xFF8c6023),
                ),
                labelStyle: TextStyle(
                  fontSize: 12, 
                ),
              ),
              style: TextStyle(fontSize: 12),
            ),
            
            SizedBox(height: 10),
            // Champ mot de passe
            TextFormField(
              controller: _passwordController,
              onChanged: (val) {
                user.password = val.trim();
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                }

                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8c6023),
                  ),
                ),
                floatingLabelStyle: const TextStyle(
                  color: Color(0xFF8c6023),
                ),
                labelStyle: TextStyle(
                  fontSize: 12, 
                ),
              ),
              style: TextStyle(fontSize: 12),
            ),
            _gap(),

            // Mot de passe oublié
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScrenn()),
                    );

                  },
                  child: const Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(
                      color: Color(0xFF8c6023),
                      decoration: TextDecoration.none,
                      fontSize: 8,
                    ),
                  ),
                ),
              ],
            ),
            _gap(),

            // Bouton de connexion
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFC3AD65),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                      overlayColor: Colors.brown.withOpacity(0.2),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Connexion',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    loginUser(_usernameController.text.trim(), _passwordController.text.trim());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Vous n'avez pas de compte ? ",
                    style: TextStyle(fontSize: 8),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Redirection vers la page de création de compte sans animation
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => SignUpScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return child; 
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Créer un compte",
                      style: TextStyle(
                        fontSize: 8,
                        color: Color(0xFF8c6023),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
