import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/recensement.dart';
import 'package:mobile_data_collection/screens/home_screen/navbar_screen.dart';
import 'package:mobile_data_collection/screens/home_screen/recensement_card.dart';
import 'package:mobile_data_collection/screens/profile/profile_screen.dart';
import 'package:mobile_data_collection/service/recensement_utilisateur_service.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_data_collection/service/storage_service.dart';
import 'package:mobile_data_collection/utils/constants.dart';



class HomeScreen extends StatefulWidget {
   final String username;
   final String email;
   final String initial;
   
  HomeScreen(this.username, this.email, this.initial);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  int _currentIndex = 0; // Index de la page active
  late Future<List<Recensement>> _recensementsFuture;
  final List<Widget> _pages = [];
  RecensementUtilisateurService recensementUtilisateurService = new RecensementUtilisateurService();
  Color customColor = kBackgroundColor;

  

  @override
  void initState() {
    super.initState();
    _recensementsFuture = recensementUtilisateurService.listerRecensementsUtilisateurActifs(widget.email);
    _pages.addAll([
      _buildHomePage(),
      NavBarScreen(),
      ProfileScreen(email: widget.email),
    ]);
  }

  

  @override
  Widget build(BuildContext context) {
    

    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: ThemeData.light().colorScheme.copyWith(primary: customColor),
        scaffoldBackgroundColor: customColor,
      ),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 148, 92, 34),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(255, 175, 174, 174),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Accueil",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: "Explorer",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: customColor,
        elevation: 1,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Accueil",
                
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
                widget.initial,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Recherche de projets...",
                hintStyle: TextStyle(fontSize: 12.0),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
               
              ),
            ),
            const SizedBox(height: 26.0),
            const Text(
              "Recensements actifs",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 83, 83, 83),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Recensement>>(
                future: _recensementsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(snapshot.data);
                    return Center(child: Text("Erreur : ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Aucun recensement actif"));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final recensement = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: RecensementCard(
                            isBrown: index % 2 == 0,
                            recensement: recensement,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}





