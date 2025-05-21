import 'package:mobile_data_collection/model/user_dto.dart';
import 'package:mobile_data_collection/screens/login_screen/login_screen.dart';
import 'package:mobile_data_collection/screens/profile/info_profil_screen.dart';
import 'package:mobile_data_collection/service/auth_service.dart';
import 'package:mobile_data_collection/service/user_service.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'package:mobile_data_collection/utils/exports.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  ProfileScreen({required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserService userService = UserService();
  late int logOut;
  UserDto? user;
  bool isLoading = true;
  String? errorMsg;
  Color customColor = kBackgroundColor;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final result = await userService.retournerUtilisateur(widget.email);
      setState(() {
        user = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              // Photo de profil avec icône caméra
              Stack(
                children: [
                  Container(
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
                ],
              ),
              const SizedBox(height: 20),
              if (isLoading)
                CircularProgressIndicator(
                  backgroundColor: Color.fromARGB(255, 249, 243, 231),
                )
              else if (errorMsg != null)
                Text(
                  'Erreur : $errorMsg',
                  style: TextStyle(color: Colors.red),
                )
              else if (user != null)
                Column(
                  children: [
                    Text(
                      user!.username ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user!.email ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ProfileMenu(
                      text: "Mes informations",
                      icon: Icons.info_outline,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoProfilScreen(user: user),
                          ),
                        );
                      },
                    ),
                  ],
                )
              else
                Text(
                  'Utilisateur introuvable',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ProfileMenu(
                text: "Gérer le compte",
                icon: Icons.settings,
                press: () {},
              ),
              ProfileMenu(
                text: "Fermer le compte",
                icon: Icons.delete_outline,
                press: () {},
              ),
              ProfileMenu(
                text: "Se déconnecter",
                icon: Icons.logout,
                press: () async {
                  // Appel au service de déconnexion
                  logOut = await userService.logout(widget.email);
                  
                  // Effacer les données de session locales
                  await AuthService.logout();
                  
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                },
              ),
            ],
          ),
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

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 148, 92, 34),
          padding: const EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF757575),
              size: 20,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 12,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

