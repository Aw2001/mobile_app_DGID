import 'package:flutter/material.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'step_list.dart';
import 'fieldBien.dart';

/// Flutter code sample for [ExpansionPanelList].

class ExpansionPanelListExampleBienApp extends StatelessWidget {
  const ExpansionPanelListExampleBienApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ExpansionPanelListExampleBien(
            nbItems: 0,
            onDelete: () {
              print("un panneau a été supprimé");
            }),
      ),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.headerValue,
    this.isExpanded = false,
  });

  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Informations sur le bien',
    );
  });
}

class ExpansionPanelListExampleBien extends StatefulWidget {
  final int nbItems;
  final VoidCallback onDelete;
  const ExpansionPanelListExampleBien({
    super.key,
    required this.nbItems,
    required this.onDelete,
  });

  @override
  State<ExpansionPanelListExampleBien> createState() =>
      _ExpansionPanelListExampleState();
}

class _ExpansionPanelListExampleState
    extends State<ExpansionPanelListExampleBien> {
  late List<Item> _data;

  @override
  void initState() {
    super.initState();
    _data = generateItems(
        widget.nbItems); // Utilise nbItems pour générer les panneaux
  }

  @override
  void didUpdateWidget(covariant ExpansionPanelListExampleBien oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.nbItems != widget.nbItems) {
      setState(() {
        _data = generateItems(widget.nbItems); // Mettez à jour les items
      });
    }
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
        return Column(
          children: [
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _data[index].isExpanded = isExpanded;
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
                        BuildFieldBien(), // Affiche les champs de texte
                        const SizedBox(
                            height:
                                10), // Espacement entre les champs et le bouton
                        ListTile(
                          trailing: const Icon(Icons.delete),
                          onTap: () {
                            setState(() {
                              _data.removeWhere(
                                  (Item currentItem) => item == currentItem);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  isExpanded: item.isExpanded,
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Espacement entre les panneaux
          ],
        );
      }).toList(),
    );
  }
}
