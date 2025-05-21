import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/recensement.dart';
import 'package:mobile_data_collection/screens/home_screen/navbar_screen.dart';
import 'package:mobile_data_collection/screens/home_screen/recensement_card.dart';
import 'package:mobile_data_collection/screens/profile/profile_screen.dart';
import 'package:mobile_data_collection/service/recensement_utilisateur_service.dart';
import 'package:mobile_data_collection/utils/constants.dart';



class HomeScreen extends StatefulWidget {
   final String username;
   final String email;
   final String initial;
   
  HomeScreen(this.username, this.email, this.initial);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  
  
  int _currentIndex = 0; // Index de la page active
  final List<Widget> _pages = [];
  RecensementUtilisateurService recensementUtilisateurService = new RecensementUtilisateurService();

  final TextEditingController _searchController = TextEditingController();
  List<Recensement> _filteredRecensements = [];
  List<Recensement> _allRecensements = [];
  bool _isLoading = true;
  Color customColor = kBackgroundColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_onSearchChanged); // Ajouter un listener
    _loadData();
    _initializePages(); // Initialiser les pages
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      // Si on revient à la page d'accueil (index 0), on recharge les données
      if (index == 0) {
        _loadData();
      }
    });
  }

  void _initializePages() {
    setState(() {
      _pages.addAll([
        _buildHomePage(),
        NavBarScreen(widget.initial),
        ProfileScreen(email: widget.email),
      ]);
    });
  }
  
  Future<void> _loadData() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      final recensements = await recensementUtilisateurService.listerRecensementsUtilisateurActifs(widget.email);
      if (!mounted) return;
      
      setState(() {
        _allRecensements = recensements;
        _filteredRecensements = recensements;
        _isLoading = false;
      });
      
      // Forcer la mise à jour des pages après le chargement des données
      _initializePages();
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des données: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

   void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _filteredRecensements = List.from(_allRecensements);
      } else {
        _filteredRecensements = _allRecensements.where((recensement) {
          return recensement.commentaire.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
      return Scaffold(
        body: _currentIndex == 0
            ? _buildHomePage() // Affiche la page d'accueil avec les recensements
            : _pages[_currentIndex], // Affiche les autres pages selon l'index
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 148, 92, 34),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(255, 175, 174, 174),
          currentIndex: _currentIndex,          onTap: _onPageChanged,
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
      actions: [
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
    body: RefreshIndicator(
      onRefresh: _loadData,
      child: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: _buildContent(),
            ),
          ),
    ),
  );
}

Widget _buildContent() {
  if (_allRecensements.isEmpty) {
    return const Center(
      child: Text(
        "Aucun recensement disponible",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de recherche
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un recensement...",
                hintStyle: TextStyle(fontSize: 10),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: TextStyle(fontSize: 10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Recensements actifs (${_filteredRecensements.length})",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 83, 83, 83),
            ),
          ),
          const Divider(thickness: 1, color: Colors.grey),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRecensements.length,
              itemBuilder: (context, index) {
                final recensement = _filteredRecensements[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: RecensementCard(
                    isBrown: index % 2 == 0,
                    recensement: recensement,
                    index: index,
                    numRecensement: recensement.numRecensement,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
}

  
}





