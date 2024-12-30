import 'package:flutter/material.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'field_locataire.dart';

class ExpansionPanelListExampleLocataireApp extends StatelessWidget {
  const ExpansionPanelListExampleLocataireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ExpansionPanelListExampleLocataire(
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
      headerValue: 'Informations sur le Locataire',
    );
  });
}

class ExpansionPanelListExampleLocataire extends StatefulWidget {
  late int nbItems;
  final VoidCallback onDelete;
  ExpansionPanelListExampleLocataire({
    super.key,
    required this.nbItems,
    required this.onDelete,
  });

  @override
  State<ExpansionPanelListExampleLocataire> createState() =>
      _ExpansionPanelListExampleState();
}

class _ExpansionPanelListExampleState extends State<ExpansionPanelListExampleLocataire> {
  late List<Item> _data;

  @override
  void initState() {
    super.initState();
    _data = generateItems(widget.nbItems);
  }

  @override
  void didUpdateWidget(covariant ExpansionPanelListExampleLocataire oldWidget) {
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
        int currentIndex = _data.indexOf(item);
        return Column(
          children: [
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _data[currentIndex].isExpanded = isExpanded;
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
                        BuildFieldLocataire(),
                        const SizedBox(height: 10),
                        ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _data.removeWhere(
                                    (Item currentItem) => item == currentItem);
                              });
                              widget.onDelete();
                            },
                          ),
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
