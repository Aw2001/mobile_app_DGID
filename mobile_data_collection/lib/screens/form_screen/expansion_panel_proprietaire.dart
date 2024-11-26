import 'package:flutter/material.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'field_proprietaire.dart';

class ExpansionPanelListExampleProprietaireApp extends StatelessWidget {
  const ExpansionPanelListExampleProprietaireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ExpansionPanelListExampleProprietaire(
            nbItems: 0,
            onDelete: () {
              print("un panneau a été supprimé");
            }),
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

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Informations sur le proprietaire',
    );
  });
}

class ExpansionPanelListExampleProprietaire extends StatefulWidget {
  final int nbItems;
  final VoidCallback onDelete;
  const ExpansionPanelListExampleProprietaire({
    super.key,
    required this.nbItems,
    required this.onDelete,
  });

  @override
  State<ExpansionPanelListExampleProprietaire> createState() =>
      _ExpansionPanelListExampleState();
}

class _ExpansionPanelListExampleState
    extends State<ExpansionPanelListExampleProprietaire> {
  late List<Item> _data;

  @override
  void initState() {
    super.initState();
    _data = generateItems(widget.nbItems);
  }

  @override
  void didUpdateWidget(
      covariant ExpansionPanelListExampleProprietaire oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.nbItems != widget.nbItems) {
      setState(() {
        _data = generateItems(widget.nbItems);
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
                        BuildFieldProprietaire(),
                        const SizedBox(height: 10),
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
            const SizedBox(height: 16.0),
          ],
        );
      }).toList(),
    );
  }
}
