import 'package:flutter/material.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'field_bien.dart';

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
  final VoidCallback onDelete;
  late int newIndex;
  ExpansionPanelListExampleBien({
    super.key,
    required this.nbItems,
    required this.onDelete,
  });

  @override
  State<ExpansionPanelListExampleBien> createState() =>
      _ExpansionPanelListExampleState();
}

class _ExpansionPanelListExampleState extends State<ExpansionPanelListExampleBien> {
  late List<Item> _data;
  var indexAjoute = 0;

  List<Item> generateItems(int numberOfItems) {
    return List<Item>.generate(numberOfItems, (int index) {
      return Item(
        headerValue: 'Informations du local',
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
                        BuildFieldBien(),
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
