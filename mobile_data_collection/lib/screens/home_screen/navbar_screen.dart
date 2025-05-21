import '../home_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'dropdown_screen.dart';
import 'package:mobile_data_collection/utils/constants.dart';

class NavBarScreen extends StatelessWidget {
  final String initial;
  NavBarScreen(this.initial);

  final GlobalKey<MapScreenState> mapScreenKey = GlobalKey<MapScreenState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color customColor = kBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;
    

    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: customColor,
            ),
        scaffoldBackgroundColor: customColor,
      ),
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: customColor,
            elevation: 0,
            titleSpacing: 0,
            leading: isLargeScreen
                ? null
                : IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
            title: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Explorer",
                
                style: TextStyle(
                    color: Color(0xFFC3AD65),
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ],
          ),
        ),
        actions:  [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFFC3AD65),
              child: Text(
                initial,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
          ),
          drawer: CustomDrawer(mapScreenKey: mapScreenKey),
          body: MapScreen(key: mapScreenKey)),
    );
  }


}
class CustomDrawer extends StatefulWidget {
  final GlobalKey<MapScreenState> mapScreenKey;
  const CustomDrawer({Key? key, required this.mapScreenKey}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  

  @override
  Widget build(BuildContext context) {
    const Color customColor = kBackgroundColor;


    return Drawer(
      backgroundColor: customColor, // Définit la couleur de fond du Drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: customColor, // Couleur de fond du Drawer Header
            ),
            child: Text(
              'Tableau de bord',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFC3AD65),
              ),
            ),
          ),
          DropdownsWidget(mapScreenKey: widget.mapScreenKey),
        ],
      ),
    );
  }
}

