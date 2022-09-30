import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tasbeeh/tasb_items.dart';

class Tasbeeh extends StatefulWidget {
  const Tasbeeh({super.key});

  @override
  State<Tasbeeh> createState() => _TasbeehState();
}

class _TasbeehState extends State<Tasbeeh> {
  final _myBox = Hive.box('myBox');

  void writeData(text) {
    setState(() {
      _myBox.add(text);
    });
    debugPrint(_myBox.values.toString());
  }

  void editData() {}

  void deleteData(id) {
    setState(() {
      _myBox.delete(id);
    });
  }

  late String valueText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasbhiyaat')),
      // backgroundColor: const Color.fromARGB(255, 63, 30, 30),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // for (Tasb tas in tasblist) TasbList(tasb: tas),

                  for (var tas in _myBox.keys)
                    TasbList2(
                      tas: tas,
                      onDeleteData: deleteData,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add Tasbeeh"),
                  content: TextField(
                    maxLines: null,
                    decoration:
                        const InputDecoration(hintText: "Enter new Tasbeeh"),
                    onChanged: (value) {
                      setState(() {
                        valueText = value;
                      });
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
                          writeData(valueText);
                          Navigator.pop(context);
                        },
                        child: const Text('Add Tasbeeh')),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
