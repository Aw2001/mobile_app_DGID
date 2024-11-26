import 'package:flutter/material.dart';
import 'package:mobile_data_collection/utils/constants.dart';
import 'field_parcelle.dart';

class ExpansionPanelListExampleApp extends StatelessWidget {
  const ExpansionPanelListExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const ExpansionPanelListExample(),
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
      headerValue: 'Informations sur la parcelle',
    );
  });
}

class ExpansionPanelListExample extends StatefulWidget {
  const ExpansionPanelListExample({super.key});

  @override
  State<ExpansionPanelListExample> createState() =>
      _ExpansionPanelListExampleState();
}

class _ExpansionPanelListExampleState extends State<ExpansionPanelListExample> {
  final List<Item> _data = generateItems(1);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
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
                BuildFieldParcelle(),
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
        );
      }).toList(),
    );
  }
}
