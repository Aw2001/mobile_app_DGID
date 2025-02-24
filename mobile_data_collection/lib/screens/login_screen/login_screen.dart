import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/login_utilisateur.dart';
import 'package:mobile_data_collection/screens/forgot_password_screnn.dart';
import 'package:mobile_data_collection/screens/home_screen/home_screen.dart';
import 'package:mobile_data_collection/service/storage_service.dart';
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
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Permet de fixer le contenu
      body: Stack(
        children: [
          Positioned(
            top: 0.05 * screenSize.height,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Logo en haut
                const SizedBox(height: 10),
                Image.asset('assets/images/logoT.png', width: 170),
                const SizedBox(height: 1),

                // Titre principal
               
                // Sous-titre "Bienvenue"
                const SizedBox(height: 1),
                const Text(
                  'Bienvenue',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC3AD65),
                  ),
                ),

                // Texte d'invitation
                const SizedBox(height: 5),
                const Text(
                  'Veuillez vous connecter pour continuer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
               

              ],
            ),
          ),

          // Contenu du formulaire en bas
          
          Positioned(
            bottom: isSmallScreen
                ? screenSize.height * 0.15
                : screenSize.height * 0.05,
            left: 0,
            right: 0,
            child: Center(
              child: isSmallScreen
                  ? const _FormContent()
                  : Container(
                      padding: const EdgeInsets.all(32.0),
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: const _FormContent(),
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = "";
  LoginUtilisateur user = LoginUtilisateur("", "");

  Future<void> loginUser(String email, String password) async {
    Uri url = Uri.parse("http://10.0.2.2:8081/auth/login");
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        String token = json.decode(response.body)['token'];
        await StorageService.writeData('jwt_token', token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(email)),
        );
      } else {
        print("Erreur ${response.statusCode} : ${response.body}");
        setState(() {
          _errorMessage = "Adresse email ou mot de passe incorrect."; // Message d'erreur
        });
      }
    } catch (e) {
      print("Erreur : $e");
      setState(() {
        _errorMessage = "Une erreur est survenue. Veuillez réessayer.";
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             if (_errorMessage.isNotEmpty)
              Column(
                 children: [
                  Padding(
                  padding: const EdgeInsets.only(bottom: 16.0), // Espacement avec les champs
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ),
                 ] 
              ),
              
            // Champ email
            TextFormField(
              controller: _emailController,
              onChanged: (val) {
                user.identifiant = val;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                }

                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Veuillez saisir une adresse email valide';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Adresse Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8c6023),
                  ),
                ),
                floatingLabelStyle: TextStyle(
                  color: Color(0xFF8c6023),
                ),
              ),
            ),
            _gap(),

            // Champ mot de passe
            TextFormField(
              controller: _passwordController,
              onChanged: (val) {
                user.password = val;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
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
              ),
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
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Connexion',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    loginUser(_emailController.text, _passwordController.text);
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
                    style: TextStyle(fontSize: 14.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Redirection vers la page de création de compte sans animation
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => SignUpScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return child; // Pas d'animation, affichage instantané
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Créer un compte",
                      style: TextStyle(
                        fontSize: 14.0,
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
