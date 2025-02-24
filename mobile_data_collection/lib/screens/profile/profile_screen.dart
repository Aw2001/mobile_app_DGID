import 'package:mobile_data_collection/model/user_dto.dart';
import 'package:mobile_data_collection/screens/login_screen/login_screen.dart';
import 'package:mobile_data_collection/screens/profile/edit_profil_screen.dart';
import 'package:mobile_data_collection/service/user_service.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'package:mobile_data_collection/utils/exports.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/service/storage_service.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final String email;

  ProfileScreen({required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserDto?> userFuture;
  Color customColor = kBackgroundColor;

  
 Future<void> logOut(String email) async {
  Uri url = Uri.parse("http://10.0.2.2:8081/auth/logout?email=$email");

  try {
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await StorageService.readData("jwt_token")}',
      },
    );

    if (response.statusCode == 200) {
      // Supprime le token après la déconnexion
      await StorageService.deleteData('jwt_token');

    } else {
      print("Erreur ${response.statusCode} : ${response.body}");
    }
  } catch (e) {
    print("Erreur : $e");
  }
}


  @override
  void initState() {
    super.initState();
    userFuture = UserService("http://10.0.2.2:8081/api/utilisateurs").retournerUtilisateur(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor,
        elevation: 1,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mon profil",
                style: TextStyle(
                    color: Color(0xFFC3AD65),
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            
            const SizedBox(height: 20),
            Center(
              child: Column(
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
                  const SizedBox(height: 20),
                  FutureBuilder<UserDto?>(
                    future: userFuture, // Future qui récupère l'utilisateur
                    builder: (BuildContext context, AsyncSnapshot<UserDto?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(backgroundColor: Color.fromARGB(255, 249, 243, 231),); // Affichage du chargement
                      } else if (snapshot.hasError) {
                        return Text(
                          'Erreur : ${snapshot.error}',
                          style: TextStyle(color: Colors.red),
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                          return Column(
                            children: [
                              Text(
                                snapshot.data!.username ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ProfileMenu(
                                text: "Mes informations",
                                icon: "assets/icons/User Icon.svg",
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfilScreen(user: snapshot.data),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                      } else {
                        return Text(
                          'Utilisateur introuvable',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      
                    },
                    
                  ),

                   
                  ],
                ),
              ),
            
            ProfileMenu(
              text: "Gérer le compte",
              icon: "assets/icons/Log out.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Fermer le compte",
              icon: "assets/icons/Log out.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Se déconnecter",
              icon: "assets/icons/Log out.svg",
              press: () {
                logOut(widget.email);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 148, 92, 34),
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
        ),
        onPressed: press,
        child: Row(
          children: [
            
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF757575),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}

