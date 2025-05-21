import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/user_dto.dart';
import 'package:mobile_data_collection/utils/constants.dart';

class InfoProfilScreen extends StatefulWidget {
  final UserDto? user;

  const InfoProfilScreen({Key? key, this.user}) : super(key: key);

  @override
  _InfoProfilScreenState createState() => _InfoProfilScreenState();
}

class _InfoProfilScreenState extends State<InfoProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 1,
        title: const Text(
          "Mes informations",
          style: TextStyle(
            color: Color(0xFFC3AD65),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              // Cercle profil identique à profile_screen.dart
              Center(
                child: Container(
                  width: 100,
                  height: 100,
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
                    color: Colors.grey[200],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoField("Prénom", widget.user?.prenom ?? ""),
                      infoField("Nom", widget.user?.nom ?? ""),
                      infoField("Email", widget.user?.email ?? ""),
                      infoField("Username", widget.user?.username ?? ""),
                      infoField("Role", widget.user?.role ?? ""),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFC3AD65),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFFE0E0E0)),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF757575),
              ),
            ),
          ),
        ],
      ),
    );
  }
}