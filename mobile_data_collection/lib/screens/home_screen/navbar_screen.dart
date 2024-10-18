import '../home_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'dropdown_screen.dart';
import 'package:mobile_data_collection/utils/constants.dart';

// ignore: must_be_immutable
class NavBarScreen extends StatelessWidget {
  NavBarScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;
    const Color customColor = kBackgroundColor; // Couleur personnalisée

    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: customColor, // Couleur personnalisée pour les éléments principaux
        ),
        scaffoldBackgroundColor: customColor, // Couleur de fond de la page
      ),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: customColor, // Couleur personnalisée pour l'AppBar
          elevation: 0,
          titleSpacing: 0,
          leading: isLargeScreen
              ? null
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Accueil",
                  style: TextStyle(
                      color: Color(0xFFC3AD65),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              
              ],
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Color(0xFFC3AD65),
                child: _ProfileIcon(),
              ),
            )
          ],
        ),
        drawer: isLargeScreen ? null : _drawer(),
        //map
        body: const MapScreen(),
      ),
    );
  }

 Widget _drawer() {
  const Color customColor = kBackgroundColor; // Ta couleur personnalisée pour le fond du Drawer

  return Drawer(
      backgroundColor: customColor, // Définit la couleur de fond du Drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              color: customColor, // Couleur de fond du Drawer Header
            ),
            child: Text(
              'Tableau de bord',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: Color(0xFFC3AD65),
              ),
            ),
          ),
          // Appel du widget contenant les Dropdowns
          DropdownsWidget(),
        ],
      ),
    );
}

}
enum Menu { itemOne, itemTwo, itemThree }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.person),
        offset: const Offset(0, 40),
        onSelected: (Menu item) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              const PopupMenuItem<Menu>(
                value: Menu.itemOne,
                child: Text('Profil'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemTwo,
                child: Text('Paramétrage'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemThree,
                child: Text('Déconnexion'),
              ),
            ]);
  }
}
