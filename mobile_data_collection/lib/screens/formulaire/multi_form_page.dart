
import 'package:mobile_data_collection/model/recensement.dart';
import 'package:mobile_data_collection/provider/recensement_provider.dart';
import 'package:mobile_data_collection/screens/formulaire/field_bienn.dart';
import 'package:mobile_data_collection/screens/formulaire/field_locataire.dart';
import 'package:mobile_data_collection/screens/formulaire/field_proprietaire.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'package:mobile_data_collection/utils/exports.dart';
import 'package:provider/provider.dart';

class MultiFormPage extends StatefulWidget {
  final Recensement recensement;
  final int index;
  final String? numRecensement;
  const MultiFormPage({super.key, required this.recensement, required this.index, required this.numRecensement});

  @override
  State<MultiFormPage> createState() => _MultiFormPageState();
}

class _MultiFormPageState extends State<MultiFormPage> {
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  late RecensementProvider recensementState;
  late RecensementData recensementData;
  int currentStep = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    recensementState = Provider.of<RecensementProvider>(context, listen: false);
    recensementData = recensementState.getRecensementData(widget.index, widget.numRecensement);
  }
  
  void ajouterInfos() {
    final BuildFieldProprietaireState buildFieldProprietaire = BuildFieldProprietaireState();
    final BuildFieldBienState buildFieldBien = BuildFieldBienState();
    final BuildFieldLocataireState buildFieldLocataire = BuildFieldLocataireState();
    
    if (recensementData.listOfControllersProprietaire.isNotEmpty) {
      int index = 0;
      for (Map<String, TextEditingController> controller in recensementData.listOfControllersProprietaire) {
        buildFieldProprietaire.ajouterProprietaire(controller, recensementData.dropdownProprietaire[index], recensementData.radioProprietaire[index]);
        index++;
      }
    } 
    if (recensementData.listOfControllersBien.isNotEmpty) {
      int index = 0;
      for (Map<String, TextEditingController> controller in recensementData.listOfControllersBien) {
        buildFieldBien.ajouterBien(controller, recensementData.dropdownBien[index], recensementData.radioBien[index], recensementData.recensementId[index]);
        index++;
      }
    } 
    if (recensementData.listOfControllersLocataire.isNotEmpty) {
      int index = 0;
      for (Map<String, TextEditingController> controller in recensementData.listOfControllersLocataire) {
        buildFieldLocataire.ajouterLocataire(controller, recensementData.dropdownLocataire[index]);
        index++;
      }
    }
    
    print("ajout terminé");
  }


  //list of steps
  List<Step> steps() => [
    Step(
      stepStyle: StepStyle(
        indexStyle: TextStyle(fontSize: 8, color: Colors.white), // Réduit la taille du numéro
      ),
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: Text(
        "Proprietaire",
        style: TextStyle(fontSize: 10),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKeys[0],
          child: Column(
            children: [
              for (int i = 0; i < recensementData.listOfControllersProprietaire.length; i++)
                recensementData.panelsProprietaire[i],
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    setState(() {
                      recensementData.nbItemsForProprietaire++;
                    });
                    recensementState.ajouterProprietaire(recensementData, widget.recensement);
                  },
                  backgroundColor: Color.fromARGB(255, 148, 92, 34),
                  label: const Text(
                    "Ajouter",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    Step(
      stepStyle: StepStyle(indexStyle: TextStyle(fontSize: 8, color: Colors.white)),
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: Text(
        "Local",
        style: TextStyle(fontSize: 10),
      ),
      content: Form(
        key: _formKeys[1],
        child: Column(
          children: [
            for (int i = 0; i < recensementData.listOfControllersBien.length; i++)
              recensementData.panelsBien[i],
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  setState(() {
                    recensementData.nbItemsForBien++;
                  });
                  recensementState.ajouterLocal(recensementData, widget.recensement);
                },
                backgroundColor: Color.fromARGB(255, 148, 92, 34),
                label: Text(
                  "Ajouter",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    Step(
      stepStyle: StepStyle(indexStyle: TextStyle(fontSize: 8, color: Colors.white)),
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: Text(
        "Locataire",
        style: TextStyle(fontSize: 10),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKeys[2],
          child: Column(
            children: [
              for (int i = 0; i < recensementData.listOfControllersLocataire.length; i++)
                recensementData.panelsLocataire[i],
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    setState(() {
                      recensementData.nbItemsForLocataire++;
                    });
                    recensementState.ajouterLocataire(recensementData, widget.recensement);
                  },
                  backgroundColor: Color.fromARGB(255, 148, 92, 34),
                  label: const Text(
                    "Ajouter",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  
  @override
  Widget build(BuildContext context) {
    return Consumer<RecensementProvider>(
      builder: (context, recensementProvider, child) {
        recensementData = recensementProvider.getRecensementData(widget.index, widget.numRecensement);
        return WillPopScope(
          // Intercepter le retour arrière pour sauvegarder les données avant de quitter
          onWillPop: () async {
            // Sauvegarder les données avant de quitter
            await recensementState.saveData();
            return true; // Autoriser le retour arrière
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kBackgroundColor,
              elevation: 1,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Recensement",
                      style: TextStyle(
                        color: Color(0xFFC3AD65),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Hero(
              tag: 'recensement_${widget.recensement.numRecensement}',
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Color.fromRGBO(195, 173, 101, 1),
                    onPrimary: Colors.white,
                  ),
                ), 
                child: Scaffold(
                  body: Stepper(
                    type: StepperType.horizontal,
                    steps: steps(),
                    currentStep: currentStep, 
                    onStepContinue: () {
                      if(_formKeys[currentStep].currentState!.validate()) {
                        if(isLastStep) {
                          setState(() => isComplete = true);
                          if(recensementData.panelsBien.isNotEmpty || recensementData.panelsProprietaire.isNotEmpty || recensementData.panelsLocataire.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  titleTextStyle: TextStyle(fontSize: 12),
                                  title: const Text('Confirmation', style: TextStyle(color: Color.fromARGB(255, 148, 92, 34)),),
                                  content: const Text('Voulez-vous confirmer les informations saisies ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color.fromRGBO(195, 173, 101, 1), 
                                      ),
                                      child: const Text('Annuler'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        ajouterInfos();
                                        // Sauvegarder explicitement les données après avoir confirmé le formulaire
                                        recensementState.saveData();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color.fromRGBO(195, 173, 101, 1), 
                                      ),
                                      child: const Text('Confirmer'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Aucune information n\'a été saisie', style: TextStyle(fontSize: 12),),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color.fromRGBO(195, 173, 101, 1), 
                                      ),
                                      child: const Text('Quitter', style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          // Sauvegarder les données avant de passer à l'étape suivante
                          recensementState.saveData();
                          setState(() => currentStep += 1);
                        }
                      }
                    },
                    onStepCancel: isFirstStep ? null : () {
                      // Sauvegarder les données avant de revenir à l'étape précédente
                      recensementState.saveData();
                      setState(() => currentStep -= 1);
                    },
                    onStepTapped: (step) {},
                    controlsBuilder: (context, details) => Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Row(
                        children: [
                          if(!isFirstStep) ...[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isFirstStep ? null : details.onStepCancel, 
                                child: const Text('Retour', style: TextStyle(fontSize: 12),))
                            ),
                          ],
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepContinue, 
                              child: Text (isLastStep ? 'Terminer' : 'Suivant', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
