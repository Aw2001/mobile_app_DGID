import 'package:flutter/material.dart';
import 'expansion_panel.dart';
import 'expansion_panel_bien.dart';

class StepList extends StatefulWidget {
  final int activeStepIndex;
  final VoidCallback onStepContinue;
  final VoidCallback onStepCancel;

  StepList({
    required this.activeStepIndex,
    required this.onStepContinue,
    required this.onStepCancel,
  });

  @override
  _StepListState createState() => _StepListState();
}

class _StepListState extends State<StepList> {
  int nbItems = 1;

  void decrementNbItems() {
    setState(() {
      if (nbItems > 0) {
        nbItems--; // Réduire nbItems seulement si > 0
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      currentStep: widget.activeStepIndex,
      onStepContinue: widget.onStepContinue,
      onStepCancel: widget.onStepCancel,
      steps: _buildSteps(),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Parcelle'),
        content: SingleChildScrollView(
          child: ExpansionPanelListExample(),
        ),
        isActive: widget.activeStepIndex >= 0,
        state: widget.activeStepIndex <= 0
            ? StepState.editing
            : StepState.complete,
      ),
      Step(
        title: const Text('Bien'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionPanelListExampleBien(
                  nbItems: nbItems, onDelete: decrementNbItems),
              const SizedBox(height: 16.0), // Espacement entre les élément
              Align(
                alignment: Alignment.centerRight, // Aligne le bouton à droite
                child: FloatingActionButton.extended(
                  onPressed: () {
                    // Action pour ajouter un panel
                    setState(() {
                      nbItems++;
                    });
                  },
                  backgroundColor: Color.fromARGB(
                      255, 148, 92, 34), // Couleur de fond du bouton
                  label: const Text(
                    "Ajouter un bien",
                    style: TextStyle(color: Colors.white), // Couleur du texte
                  ),
                  icon: Icon(Icons.add, color: Colors.white), // Icône du bouton
                ),
              ),
            ],
          ),
        ),
        isActive: widget.activeStepIndex >= 1,
        state: widget.activeStepIndex <= 1
            ? StepState.editing
            : StepState.complete,
      ),
      Step(
        title: const Text('Proprietaire'),
        content: SingleChildScrollView(
          child: ExpansionPanelListExample(),
        ),
        isActive: widget.activeStepIndex >= 2,
        state: widget.activeStepIndex <= 2
            ? StepState.editing
            : StepState.complete,
      ),
      // Ajoutez d'autres étapes ici si nécessaire
    ];
  }
}
