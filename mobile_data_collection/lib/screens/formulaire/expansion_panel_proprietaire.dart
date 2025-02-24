import 'package:flutter/material.dart';
import 'package:mobile_data_collection/screens/formulaire/field_bienn.dart';
import 'package:mobile_data_collection/screens/formulaire/field_proprietaire.dart';
import 'package:mobile_data_collection/utils/constants.dart';


class ExpansionPanelListExampleApp extends StatelessWidget {
  
  const ExpansionPanelListExampleApp({super.key});
  
  get controllers => null;
  
  get fields => null;
  
  get dropdownProprietaire => {};
  
  get radioProprietaire => null;
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ExpansionPanelListExampleProprietaire(
            headerValue: '',
            nbItems: 0,
            onDelete: () {
              print("un panneau a été supprimé");
            },
            controllers: controllers,
            dropdownProprietaire: dropdownProprietaire,
            radioProprietaire: radioProprietaire,
            fields: fields,),
      ),
    );
  }
}

class Item {
  Item({
    required this.headerValue,
    this.isExpanded = false,
  });

  String headerValue;
  bool isExpanded;
}



class ExpansionPanelListExampleProprietaire extends StatefulWidget {
  late int nbItems;
  
  final List<Map<String, String>> fields;
  final Map<String, TextEditingController> controllers;
  final Map<String, String?> dropdownProprietaire;
  final Map<String, String?> radioProprietaire;
  final VoidCallback onDelete;
  final String headerValue;

  
  
  ExpansionPanelListExampleProprietaire({
    super.key,
    required this.nbItems,
    required this.headerValue,
    required this.onDelete,
    required this.controllers, 
    required this.fields, required this.dropdownProprietaire, required this.radioProprietaire
    
  });

  @override
  State<ExpansionPanelListExampleProprietaire> createState() =>
      _ExpansionPanelListExampleState();
}

class _ExpansionPanelListExampleState extends State<ExpansionPanelListExampleProprietaire> {
  late List<Item> _data;
  var indexAjoute = 0;

  List<Item> generateItems(int numberOfItems) {
    return List<Item>.generate(1, (int index) {
      return Item(
        headerValue: widget.headerValue,
      );
    });
  }

  @override
  void didUpdateWidget(covariant ExpansionPanelListExampleProprietaire oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.nbItems != widget.nbItems) {
      setState(() {
        _data = generateItems(widget.nbItems);
      });
      print(_data.indexed);
    }
  }

  @override
  void initState() {
    super.initState();
    _data = generateItems(widget.nbItems);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return Column(
      children: _data.map<Widget>((Item item) {
        int currentIndex = _data.indexOf(item);
        return Column(
          children: [
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _data[currentIndex].isExpanded = isExpanded;
                  print(currentIndex);
                });
              },
              children: [
                ExpansionPanel(
                  backgroundColor: kBackgroundColor,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(item.headerValue),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        BuildFieldProprietaire(
                          controllers: widget.controllers,
                          dropdownProprietaire: widget.dropdownProprietaire,
                          radioProprietaire: widget.radioProprietaire,
                          fields: widget.fields),
                        const SizedBox(height: 1),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          onTap: () {
                            setState(() {
                              _data.removeWhere(
                                  (Item currentItem) => item == currentItem);
                            });
                            widget.onDelete();
                          },
                        ),
                      ],
                    ),
                  ),
                  isExpanded: item.isExpanded,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
          ],
        );
      }).toList(),
    );
  }
}
