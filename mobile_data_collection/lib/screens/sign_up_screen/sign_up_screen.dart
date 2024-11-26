import 'package:flutter/material.dart';
import 'package:mobile_data_collection/screens/login_screen/login_screen.dart';

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
            top: isSmallScreen
                ? screenSize.height * 0.1
                : screenSize.height * 0.2,
            left: 20,
            child: const Text(
              'Créer un compte',
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
                : screenSize.height * 0.5,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                } else if (value.length < 6) {
                  return 'Le mot de passe doit au moins contenir 6 caractères';
                } else {
                  return null;
                }
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
                    /// do something
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
                Text('Vous avez déjà un compte ?'),
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
                    'Se connecter',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  /// do something
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
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
