import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/login_utilisateur.dart';
import 'package:mobile_data_collection/utils/constants.dart';


class ForgotPasswordScrenn extends StatefulWidget {
  const ForgotPasswordScrenn({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScrenn> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Permet de fixer le contenu
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 1,
       
      ),
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
                  'Mot de passe oublié ?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC3AD65),
                  ),
                ),

                // Texte d'invitation
                const SizedBox(height: 5),
                const Text(
                  'Veuillez saisir votre mail, vous recevrez un code de validation',
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
                      padding: const EdgeInsets.all(100),
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
  final TextEditingController _emailController = TextEditingController();

  final String _errorMessage = "";
  LoginUtilisateur user = LoginUtilisateur("", "");

  

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
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                   
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
