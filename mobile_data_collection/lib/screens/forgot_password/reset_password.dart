 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/screens/login_screen/login_screen.dart';
import 'package:mobile_data_collection/utils/constants.dart';

class ResetPasswordPageScreen extends StatefulWidget {
  final String email;
  const ResetPasswordPageScreen({super.key, required this.email});

  @override
  State<StatefulWidget> createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPageScreen> {
 
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false, // Permet de fixer le contenu
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 1,
       
      ),
      body: Stack(
        children: [
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Logo en haut
                Image.asset('assets/images/logoT.png', width: 150),
                Text(
                  "Modifier votre mot de passe",
                  style: TextStyle(fontSize: 18, color: Color(0xFFC3AD65)),
                ),

                // Texte d'invitation
                SizedBox(height: 5),
                  Text(
                    'Veuillez saisir votre nouveau mot de passe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 10),
                  _FormContent(email: widget.email)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  final String email;
  const _FormContent({required this.email});

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
 
  String successMessage = "";
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _confirmPassWordController = TextEditingController();
  
  Future<void> resetPassword(String email, String password, String repeatPassword )async {
    Uri url = Uri.parse("http://teranga-gestion.kheush.xyz:8081/auth/resetPassword/$email");
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', 
        },
        body: json.encode({
          'password': password,
          'repeatPassword': repeatPassword,
        
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          successMessage = 'Le mot de passe a bien été modifié';
        });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      } else {
        print("Erreur ${response.statusCode} : ${response.body}");
        successMessage = 'Veuillez valider à nouveau';
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
             if (successMessage.isNotEmpty)
              Column(
                 children: [
                  if (successMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        successMessage,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                 
                 ] 
              ),
              
            // Champ password
            TextFormField(
              controller: _passWordController,
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
            ),
            _gap(),
            TextFormField(
              controller: _confirmPassWordController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                } else if (value != _passWordController.text) {
                  return 'Les mots de passe ne correspondent pas';
                } else {
                  return null;
                }
              },
              obscureText: _isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirmer le mot de passe',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
                    'Valider',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    resetPassword(widget.email, _passWordController.text, _confirmPassWordController.text);
                  }
                },
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
  
}