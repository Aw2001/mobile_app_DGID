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

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          child: Stack(
            children: [
             
              Positioned(
                top: 80,
                left: 20,
                right: 20,
                child: Column(
                  
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logoT.png', width: 150),
                    Text(
                      "Bienvenue",
                      style: TextStyle(fontSize: 18, color: Color(0xFFC3AD65)),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Veuillez vous connecter pour continuer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 10),
                    _FormContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
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
  String initial = '';
  String email = '';
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = "";
  LoginUtilisateur user = LoginUtilisateur("", "");

  Future<void> retourneInitial(String username) async {
    
    Uri url = Uri.parse("http://192.168.1.7:8081/api/utilisateurs/initial/$username");
    try {
      // Récupérer le token JWT depuis le stockage local
      final String? token = await StorageService.readData('jwt_token');

      // Vérifiez si le token est null
      if (token == null) {
        throw Exception('Token introuvable, veuillez vous reconnecter.');
      }

      // Envoi de la requête HTTP
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
       if (response.statusCode == 200) {
        if (response.body.isEmpty) {
           print("aucune reponse");
        } else {
          String fullName = response.body; 
        
          // Séparation de la chaîne en mots
          List<String> nameParts = fullName.split(','); 
          List<String> firstNameParts = nameParts[0].split(' ');
          List<String> secondNameParts = nameParts[1].split(' ');
          String firstInitial = firstNameParts[0][0];
          String secondInitial = secondNameParts[0][0];
          
          setState(() {
            initial = firstInitial + secondInitial; // Mise à jour de l'état avec les initiales
            
          });
          
        }
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
      
    } catch (e) {
      print("Erreur : $e");
      
    }
  }
  Future<void> loginUser(String username, String password) async {
    Uri url = Uri.parse("http://192.168.1.7:8081/auth/login");
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        String token = json.decode(response.body)['token'];
        await StorageService.writeData('jwt_token', token);
        retourneInitial(username);
        Uri url1 = Uri.parse("http://192.168.1.7:8081/api/utilisateurs/getEmail/$username");
        try {
          // Récupérer le token JWT depuis le stockage local
          final String? token = await StorageService.readData('jwt_token');

          // Vérifiez si le token est null
          if (token == null) {
            throw Exception('Token introuvable, veuillez vous reconnecter.');
          }

          // Envoi de la requête HTTP
          final response = await http.get(
            url1,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );
          if (response.statusCode == 200) {
            if (response.body.isEmpty) {
              print("aucune reponse");
            } else {
              email = response.body;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(username, email, initial)),
              );
            }
          } else {
            throw Exception('Erreur serveur : ${response.statusCode}');
          }
          
        } catch (e) {
          print("Erreur : $e");
          
        }

        
      } else {
        print("Erreur ${response.statusCode} : ${response.body}");
        setState(() {
          _errorMessage = "Username ou mot de passe incorrect."; // Message d'erreur
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
                user.identifiant = val;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
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
            ),
            
            SizedBox(height: 10),
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
                labelStyle: TextStyle(
                  fontSize: 12, 
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
                      fontSize: 10,
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
                    loginUser(_usernameController.text, _passwordController.text);
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
                    style: TextStyle(fontSize: 10.0),
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
                        fontSize: 10.0,
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
