import 'package:flutter/material.dart';
import 'expansion_panel_proprietaire.dart';
import 'expansion_panel.dart';
import 'expansion_panel_bien.dart';

class StepList extends StatefulWidget {
  final int activeStepIndex;
  final VoidCallback onStepContinue;
  final VoidCallback onStepCancel;

  const StepList({
    super.key,
    required this.activeStepIndex,
    required this.onStepContinue,
    required this.onStepCancel,
  });

  @override
  StepListState createState() => StepListState();
}

class StepListState extends State<StepList> {
  int nbItemsForBien = 1;
  int nbItemsForProprietaire = 1;

  void decrementNbItemsForBien() {
    setState(() {
      if (nbItemsForBien > 0) {
        nbItemsForBien--; // Réduire nbItems seulement si > 0
      }
    });
  }

  void decrementNbItemsForProprietaire() {
    setState(() {
      if (nbItemsForProprietaire > 0) {
        nbItemsForProprietaire--; // Réduire nbItems seulement si > 0
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
                  nbItems: nbItemsForBien, onDelete: decrementNbItemsForBien),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      nbItemsForBien++;
                    });
                  },
                  backgroundColor: Color.fromARGB(255, 148, 92, 34),
                  label: const Text(
                    "Ajouter un bien",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(Icons.add, color: Colors.white),
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
          child: Column(
            children: [
              ExpansionPanelListExampleProprietaire(
                  nbItems: nbItemsForProprietaire,
                  onDelete: decrementNbItemsForProprietaire),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      nbItemsForProprietaire++;
                    });
                  },
                  backgroundColor: Color.fromARGB(255, 148, 92, 34),
                  label: const Text(
                    "Ajouter un proprietaire",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        isActive: widget.activeStepIndex >= 2,
        state: widget.activeStepIndex <= 2
            ? StepState.editing
            : StepState.complete,
      ),
    ];
  }
}
