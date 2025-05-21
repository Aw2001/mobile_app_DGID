import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/register_user.dart';
import 'package:mobile_data_collection/screens/login_screen/login_screen.dart';
import 'package:mobile_data_collection/screens/sign_up_screen/otp_page_screen.dart';
import 'package:mobile_data_collection/utils/exports.dart';
import 'package:mobile_data_collection/utils/extensions.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                        'Création de compte',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFC3AD65),
                          fontWeight: FontWeight.bold,
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
  String _errorMessage = "Après validation veuillez patientez svp!";
  String _errorCode = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  RegisterUserDto user = RegisterUserDto("", "", "", "", "", "", "");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> signUpUser(String email, String prenom, String nom, String username, String password) async {
    Uri url = Uri.parse("http://teranga-gestion.kheush.xyz:8081/auth/signup");
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Assurez-vous que le type est correct
        },
        body: json.encode({
          'email': email,
          'prenom': prenom,
          'nom': nom,
          'username': username,
          'password': password,
          'role': 'Agent de terrain',
          'typePlateforme': 'MOBILE'
        }),
      );

      if (response.statusCode == 200) {
      
        _errorCode = 'Code de vérification envoyé !';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OtpPageScreen(email: _emailController.text, message: _errorCode),),
        );
      } else {
        print("Erreur ${response.statusCode} : ${response.body}");
        setState(() {
            _errorMessage = "le code n'a pas pu être envoyé"; // Message d'erreur
          });
      }
    } catch (e) {
      print("Erreur : $e");
    }
}


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
                   Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                 ] 
              ),
              SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                } else {
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);

                  if (!emailValid) {
                    return 'Veuillez saisir une adresse email valide';
                  } else {
                    return null;
                  }
                }
              },
              decoration: const InputDecoration(
                labelText: 'Adresse Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color(0xFF8c6023),
                )),
                floatingLabelStyle: TextStyle(
                  color: Color(0xFF8c6023), // Couleur du label en focus
                ),
                labelStyle: TextStyle(
                  fontSize: 11, 
                ),
              ),
              style: TextStyle(fontSize: 12),
            ),
            _gap(),
            TextFormField(
              controller: _prenomController,
              inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z]+|\s"),
                    )
                  ],
                  validator: (val) {
                    if(val == null || val.trim().isEmpty) {
                      return 'Ce champ ne peut pas être vide';
                    }
                    else if(!val.trim().isValidName) {
                      return 'Veuiller saisir un nom valide'; 
                    }
                    else {
                      return null;
                    }
                    
                  },
              decoration: const InputDecoration(
                labelText: 'Prenom',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color(0xFF8c6023),
                )),
                floatingLabelStyle: TextStyle(
                  color: Color(0xFF8c6023), // Couleur du label en focus
                ),
                labelStyle: TextStyle(
                  fontSize: 12, 
                ),
              ),
              style: TextStyle(fontSize: 12),
            ),
            _gap(),
            TextFormField(
              controller: _nomController,
              inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z]+|\s"),
                    )
                  ],
                  validator: (val) {
                    if(val == null || val.trim().isEmpty) {
                      return 'Ce champ ne peut pas être vide';
                    }
                    else if(!val.trim().isValidName) {
                      return 'Veuiller saisir un nom valide'; 
                    }
                    else {
                      return null;
                    }
                    
                  },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Nom',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color(0xFF8c6023),
                )),
                floatingLabelStyle: TextStyle(
                  color: Color(0xFF8c6023), // Couleur du label en focus
                ),
                labelStyle: TextStyle(
                  fontSize: 12, 
                ),
              ),
              style: TextStyle(fontSize: 12),
            ),
            _gap(),
             TextFormField(
              controller: _usernameController,
              validator: (val) {
                    if(val == null || val.trim().isEmpty) {
                      return 'Ce champ ne peut pas être vide';
                    }
                    else {
                      return null;
                    }
                    
                  },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Username',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color(0xFF8c6023),
                )),
                floatingLabelStyle: TextStyle(
                  color: Color(0xFF8c6023), // Couleur du label en focus
                ),
                labelStyle: TextStyle(
                  fontSize: 12, 
                ),
              ),
              style: TextStyle(fontSize: 12),
            ),
            _gap(),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                } else if (value.trim().length < 4) {
                  return 'Le mot de passe doit au moins contenir 6 caractères';
                } else {
                  return null;
                }
              },
              obscureText: _isPasswordVisible,
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
                )),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFC3AD65),
                  overlayColor: Colors.brown.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    
                    signUpUser(_emailController.text.trim(), _prenomController.text.trim(), _nomController.text.trim(), _usernameController.text.trim(), _passwordController.text.trim());
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
                    "Vous avez un compte ? ",
                    style: TextStyle(fontSize: 8.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      
                      // Redirection vers la page de création de compte
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return child; // Pas d'animation, affichage instantané
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(
                        fontSize: 8.0,
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

  Widget _gap() => const SizedBox(height: 10);
}
