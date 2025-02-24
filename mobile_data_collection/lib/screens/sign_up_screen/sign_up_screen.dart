import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/register_user.dart';
import 'package:mobile_data_collection/screens/login_screen/login_screen.dart';
import 'package:mobile_data_collection/screens/sign_up_screen/otp_page_screen.dart';
import 'package:mobile_data_collection/utils/exports.dart';
import 'package:mobile_data_collection/utils/extensions.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      resizeToAvoidBottomInset: false, //permettre de fixer le contenu
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

                const Text(
                  'Création de compte',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC3AD65),
                  ),
                ),
               

              ],
            ),
          ),
          Positioned(
            bottom: isSmallScreen
                ? screenSize.height * 0.15
                : screenSize.height * 0.004,
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
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  RegisterUserDto user = RegisterUserDto("", "", "", "", "", "");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> SignUpUser(String email, String prenom, String nom, String password) async {
  Uri url = Uri.parse("http://10.0.2.2:8081/auth/signup");
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
        'username': '',
        'password': password,
        'role': ''
      }),
    );

    if (response.statusCode == 200) {
    

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OtpPageScreen(email: email,)),
      );
    } else {
      print("Erreur ${response.statusCode} : ${response.body}");
    }
  } catch (e) {
    print("Erreur : $e");
  }
}


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
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
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
              ),
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
                    if(val == null || val.isEmpty) {
                      return 'Ce champ ne peut pas être vide';
                    }
                    else if(!val.isValidName) {
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
              ),
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
                    if(val == null || val.isEmpty) {
                      return 'Ce champ ne peut pas être vide';
                    }
                    else if(!val.isValidName) {
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
              ),
            ),
            _gap(),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                } else if (value.length < 6) {
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
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFC3AD65),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    SignUpUser(_emailController.text, _prenomController.text, _nomController.text, _passwordController.text);
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
                    style: TextStyle(fontSize: 14.0),
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
