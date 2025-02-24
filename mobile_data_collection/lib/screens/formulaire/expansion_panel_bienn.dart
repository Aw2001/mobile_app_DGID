import 'package:flutter/material.dart';
import 'package:mobile_data_collection/model/recensement.dart';
import 'package:mobile_data_collection/screens/formulaire/field_bienn.dart';
import 'package:mobile_data_collection/utils/constants.dart';


class ExpansionPanelListExampleBienApp extends StatelessWidget {
  
  const ExpansionPanelListExampleBienApp({super.key});
  
  get recensement => null;
  
  get controllers => null;

  get radioBien => null;

  get dropDownBien => null;
  
  get fieldsBien => null;
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ExpansionPanelListExampleBien(
            headerValue: '',
            recensement: recensement,
            nbItems: 0,
            onDelete: () {
              print("un panneau a été supprimé");
            },
            controllers: controllers,
            dropDownBien: dropDownBien,
            radioBien: radioBien,
            fieldsBien: fieldsBien,),
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



class ExpansionPanelListExampleBien extends StatefulWidget {
  late int nbItems;
  final Recensement recensement;
  final List<Map<String, String>> fieldsBien;
  final Map<String, TextEditingController> controllers;
  final Map<String, String?> radioBien;
  final Map<String, String?> dropDownBien;
  final VoidCallback onDelete;
  final String headerValue;

  
  
  ExpansionPanelListExampleBien({
    super.key,
    required this.nbItems,
    required this.headerValue,
    required this.onDelete,
    required this.recensement,
    required this.controllers, 
    required this.fieldsBien, required this.radioBien, required this.dropDownBien
  });

  @override
  State<ExpansionPanelListExampleBien> createState() =>
      _ExpansionPanelListExampleState();
}

class _ExpansionPanelListExampleState extends State<ExpansionPanelListExampleBien> {
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
  void didUpdateWidget(covariant ExpansionPanelListExampleBien oldWidget) {
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
                        BuildFieldBien(
                          recensement: widget.recensement,
                          controllers: widget.controllers,
                          dropDownBien: widget.dropDownBien,
                          radioBien: widget.radioBien,
                          fieldsBien: widget.fieldsBien),
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
