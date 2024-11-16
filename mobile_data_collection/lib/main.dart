import 'package:mobile_data_collection/screens/home_screen/navbar_screen.dart';
import 'package:mobile_data_collection/screens/welcome_screen.dart';
import 'package:mobile_data_collection/screens/form_screen/multi_step_screen.dart';
import 'utils/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application de collecte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
                fontFamily: 'Roboto-Regular',
              )),
      home: NavBarScreen(),
    );
  }
}