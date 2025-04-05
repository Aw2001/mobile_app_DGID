import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/verify_user.dart';
import 'package:mobile_data_collection/screens/login_screen/login_screen.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

class OtpPageScreen extends StatefulWidget {
  final String email;
  final String message;
  const OtpPageScreen({super.key, required this.email, required this.message});

  @override
  State<StatefulWidget> createState() => OtpPageState();
}

class OtpPageState extends State<OtpPageScreen> {
  final TextEditingController _codeController = TextEditingController();
  String errorMessage = "";
 
  VerifyUserDto user = VerifyUserDto("", "");
  
  Future<void> VerifyUser(String email, String code) async {
  Uri url = Uri.parse("http://192.168.1.7:8081/auth/verify");
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
        MaterialPageRoute(builder: (context) => LoginScreen()),
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
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: kBackgroundColor,
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
                  fontSize: 18,
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: const Text(
                  "Renseigner le code envoyé à votre adresse email",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
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
              const SizedBox(height: 40), // Espacement avant le bouton
              ElevatedButton(
                onPressed: () {
                  String code = _codeController.text;
                  if (code.isNotEmpty) {
                    // Appel à la fonction de validation
                    VerifyUser(widget.email, code);
                  } else {
                    // Afficher un message d'erreur si le code est vide
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Veuillez entrer le code')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFC3AD65), // Couleur du bouton
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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