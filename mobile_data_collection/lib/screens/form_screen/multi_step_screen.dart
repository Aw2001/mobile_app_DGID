import 'package:flutter/material.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'step_list.dart';

class MultiStepScreen extends StatefulWidget {
  const MultiStepScreen({super.key});

  @override
  MultiStepScreenState createState() => MultiStepScreenState();
}

//classe principale
class MultiStepScreenState extends State<MultiStepScreen> {
  int _activeStepIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Recensement",
                style: TextStyle(
                  color: Color(0xFFC3AD65),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary:
                Color(0xFFC3AD65), // Couleur pour tous les états des étapes
            onPrimary: Colors.white, // Couleur du texte dans les icônes
          ),
        ),
        child: StepList(
          activeStepIndex: _activeStepIndex,
          onStepContinue: () {
            setState(() {
              if (_activeStepIndex < 2) {
                _activeStepIndex += 1;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (_activeStepIndex > 0) {
                _activeStepIndex -= 1;
              }
            });
          },
        ),
      ),
    );
  }
}
