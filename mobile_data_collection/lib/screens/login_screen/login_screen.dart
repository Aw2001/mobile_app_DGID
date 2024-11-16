import 'package:flutter/material.dart';
import '../welcome_screen.dart';
import '../sign_up_screen/sign_up_screen.dart';
import '../home_screen/navbar_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      resizeToAvoidBottomInset: false, //permettre de fixer le contenu
      body: Stack(
        children: [
          Positioned(
            top: -160,
            left: -30,
            child: topWidget(screenSize.width),
          ),
          Positioned(
            top: isSmallScreen
                ? screenSize.height * 0.1
                : screenSize.height * 0.2,
            left: 20, // 20 pixels depuis la gauche
            child: const Text(
              'Se connecter',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: isSmallScreen
                ? screenSize.height * 0.4
                : screenSize.height *
                    0.5, // Ajuste la position selon la taille de l'écran
            left: 0,
            right: 0,
            child: Center(
                child: isSmallScreen
                    ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _FormContent(),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(32.0),
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Center(child: _FormContent()),
                            ),
                          ],
                        ),
                      )),
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                }

                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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
                )),
                // Style du label lorsqu'il est en focus
                floatingLabelStyle: TextStyle(
                  color: Color(0xFF8c6023), // Couleur du label en focus
                ),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                }

                // if (value.length < 6) {
                //   return 'Password must be at least 6 characters';
                // }
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
                )),
                // Style du label lorsqu'il est en focus
                floatingLabelStyle: const TextStyle(
                  color: Color(0xFF8c6023), // Couleur du label en focus
                ),
              ),
            ),
            _gap(),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Aligne le texte à droite
              children: [
                GestureDetector(
                  onTap: () {
                    // Logique de "Mot de passe oublié" ici
                  },
                  child: const Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(
                      color: Color(
                          0xFF8c6023), // Vous pouvez personnaliser la couleur
                      decoration: TextDecoration.none, // Souligne le texte
                    ),
                  ),
                ),
              ],
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
                    'Connexion',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    /// do something
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NavBarScreen()),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
                Text('Vous n\'avez pas de compte ?'),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFFC3AD65),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  side: const BorderSide(
                    color: Color(0xFFc3AD65),
                    width: 2,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  /// do something
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
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
