import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TasbList2 extends StatefulWidget {
  // final Tasb tasb;
  // const TasbList({super.key, required this.tasb});
  final int tas;
  final dynamic onDeleteData;

  const TasbList2({
    super.key,
    required this.tas,
    required this.onDeleteData,
  });

  @override
  State<TasbList2> createState() => _TasbList2State();
}

class _TasbList2State extends State<TasbList2> {
  final _myBox = Hive.box('myBox');

  late String valueText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
          onTap: () {
            debugPrint("clicked list item");
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // tileColor: Colors.amber,
          title: Text(_myBox.get(widget.tas)),
          trailing: Wrap(
            spacing: 6,
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  // color: Colors.white,
                  icon: const Icon(Icons.edit),
                  iconSize: 18,
                  onPressed: () {
                    debugPrint(widget.tas.toString());
                    // _myBox.put(tas, "value");
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Tasbeeh"),
                          content: TextField(
                            controller: TextEditingController()
                              ..text = _myBox.get(widget.tas),
                            maxLines: null,
                            decoration: const InputDecoration(
                                hintText: "Enter new Tasbeeh"),
                            onChanged: (value) {
                              valueText = value;
                            },
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  debugPrint('pressed cancel');
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            ElevatedButton(
                                onPressed: () {
                                  debugPrint('pressed Submit $valueText');
                                  // writeData(valueText);
                                  setState(() {
                                    _myBox.put(widget.tas, valueText);
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Add Tasbeeh')),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  // color: Colors.white,
                  icon: const Icon(Icons.delete),
                  iconSize: 18,
                  onPressed: () {
                    debugPrint(widget.tas.toString());
                    widget.onDeleteData(widget.tas);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
