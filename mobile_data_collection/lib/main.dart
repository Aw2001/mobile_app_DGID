import 'utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:mobile_data_collection/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Application de collecte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black, fontFamily: 'Roboto')
        
      ),
      home: const WelcomeScreen(),
    );
  }
}

