import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/model/login_utilisateur.dart';
import 'package:mobile_data_collection/screens/forgot_password/otp_forgot_password.dart';
import 'package:mobile_data_collection/utils/constants.dart';

class ForgotPasswordScrenn extends StatefulWidget {
  const ForgotPasswordScrenn({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

String _errorCode = "";
String _errorMessage = "";
final TextEditingController _emailController = TextEditingController();

class _ForgotPasswordState extends State<ForgotPasswordScrenn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // ou null pour hériter du Scaffold
        elevation: 0,
        automaticallyImplyLeading: true, // affiche la flèche de retour si possible
      ),
      backgroundColor: const Color(0xFFF7F6F2),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            
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
                        "Mot de passe oublié ?",
                        style: TextStyle(fontSize: 18, color: Color(0xFFC3AD65)),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Veuillez saisir votre adresse email, vous recevrez un code de validation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
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
  LoginUtilisateur user = LoginUtilisateur("", "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> forgotPassword(String email) async {
    Uri url = Uri.parse("http://teranga-gestion.kheush.xyz:8081/auth/forgotPassword/$email");

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        _errorCode = 'Code de vérification envoyé !';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpForgotPasswordPageScreen(
                email: _emailController.text, message: _errorCode),
          ),
        );
      } else {
        print("Erreur ${response.statusCode} : ${response.body}");
        setState(() {
          _errorMessage = "le code n'a pas pu être envoyé";
        });
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
            if (_errorMessage.isNotEmpty)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
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
                labelStyle: TextStyle(fontSize: 12),
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
              style: TextStyle(fontSize: 12),
            ),
            _gap(),
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
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    forgotPassword(_emailController.text.trim());
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
