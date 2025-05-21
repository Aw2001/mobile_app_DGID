import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_data_collection/screens/forgot_password/reset_password.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

class OtpForgotPasswordPageScreen extends StatefulWidget {
  final String email;
  final String message;
  const OtpForgotPasswordPageScreen({super.key, required this.email, required this.message});

  @override
  State<StatefulWidget> createState() => OtpForgotPasswordPageState();
}

class OtpForgotPasswordPageState extends State<OtpForgotPasswordPageScreen> {
  final TextEditingController _codeController = TextEditingController();
  String errorMessage = "";
 
  
  
  Future<void> verifyUser(String email, String code) async {
  Uri url = Uri.parse("http://teranga-gestion.kheush.xyz:8081/auth/verify");
  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Assurez-vous que le type est correct
      },
      body: json.encode({
        'email': email,
        'verificationCode': code,
       
      }),
    );

    if (response.statusCode == 200) {
    

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordPageScreen(email: email)),
      );
    } else {
      print("Erreur ${response.statusCode} : ${response.body}");
      errorMessage = 'Le code saisi est incorrect';
    }
  } catch (e) {
    print("Erreur : $e");
  }
}

  @override
  Widget build(BuildContext context) {
    
    final defaultPinTheme = PinTheme(
      width: 46,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 228, 224, 201),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.message,
                style: const TextStyle(
                  color: Color(0xFFC3AD65),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          width: double.infinity,
          child: Column(
            children: [
              const Text(
                "Verification",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: const Text(
                  "Renseigner le code envoyé à votre adresse email",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 5,),
              Pinput(
                controller: _codeController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Color(0xFFC3AD65)),
                  ),
                ),
                onCompleted: (pin) => debugPrint(pin),
                
              ),
              const SizedBox(height: 20), // Espacement avant le bouton
              ElevatedButton(
                onPressed: () {
                  String code = _codeController.text;
                  if (code.isNotEmpty) {
                    // Appel à la fonction de validation
                    verifyUser(widget.email, code);
                  } else {
                    // Afficher un message d'erreur si le code est vide
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Veuillez entrer le code')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFC3AD65),
                  
                ),
                child: const Text("Valider le code"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}