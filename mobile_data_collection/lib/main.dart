import 'package:mobile_data_collection/provider/location_provider.dart';
import 'package:mobile_data_collection/provider/recensement_provider.dart';
import 'package:mobile_data_collection/screens/welcome_screen.dart';
import 'package:mobile_data_collection/service/navigation_service.dart';
import 'package:provider/provider.dart';
import 'utils/constants.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final recensementProvider = RecensementProvider();
  await recensementProvider.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DropdownState()),
        ChangeNotifierProvider(create: (_) => RecensementProvider(),),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Application de collecte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F6F2),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          fontFamily: 'Roboto-Regular',
        ),
      ),
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
      initialRoute: '/',
      home: const WelcomeScreen()
    );
  }
}
