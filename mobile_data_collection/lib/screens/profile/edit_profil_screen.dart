import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/user_dto.dart';
import 'package:mobile_data_collection/screens/home_screen/home_screen.dart';
import 'package:mobile_data_collection/screens/profile/profile_screen.dart';

class EditProfilScreen extends StatefulWidget {
  final UserDto? user;

  const EditProfilScreen({Key? key, this.user}) : super(key: key);

  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  
  bool _isPasswordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC3AD65),
        elevation: 1,
        
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 20, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Informations personnelles",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Color(0xFF8c6023)),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 60, // Taille de l'icône
                              color: Colors.grey[700], // Couleur de l'icône
                            ),
                          ),
                    ),
                   
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              buildTextField("Prénom", widget.user?.prenom ?? "", false),
              buildTextField("Nom", widget.user?.nom ?? "", false),
              buildTextField("Email", widget.user?.email ?? "", false),
              buildTextField("Username", widget.user?.username ?? "", false),
              buildTextField("Role", widget.user?.role ?? "", false),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                 

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String labelText, String placeholder, bool isPasswordTextField) {
  return StatefulBuilder(
    builder: (context, setState) {
      

      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: TextField(
          obscureText: isPasswordTextField ? _isPasswordVisible : false,
          decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      );
    },
  );
}


}