import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasbeeh/listmodel.dart';

class MyTasbForm extends StatefulWidget {
  final Function update;
  const MyTasbForm({super.key, required this.update});

  @override
  State<MyTasbForm> createState() => _MyTasbFormState();
}

class _MyTasbFormState extends State<MyTasbForm> {
  final tBox = Hive.box('tasbeehBox');

  String tTitle = "";
  String tText = "";
  int tTarget = 0;
  int tCount = 0;

  void writeData() {
    setState(() {
      tBox.add(TasbeehModel(
          title: tTitle, text: tText, target: tTarget, count: tCount));
    });
    debugPrint(tBox.values.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Tasbeeh"),
      content: buildContainer(),
      actions: [
        TextButton(
            onPressed: () {
              debugPrint('pressed cancel');
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: () {
              writeData();
              widget.update();
              Navigator.pop(context);
            },
            child: const Text('Add Tasbeeh')),
      ],
    );
  }

  Widget buildContainer() => Container(
        width: 550,
        height: 550,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              buildTitle(),
              const SizedBox(
                height: 24,
              ),
              buildText(),
              const SizedBox(
                height: 24,
              ),
              buildTarget(),
              const SizedBox(
                height: 24,
              ),
              buildCount(),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextField(
        onChanged: (value) => setState(() => tTitle = value),
        decoration: const InputDecoration(
          labelText: "Title",
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
      );
  Widget buildText() => TextField(
        onChanged: (value) => setState(() => tText = value),
        decoration: const InputDecoration(
          labelText: "Text",
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
      );
  Widget buildTarget() => TextField(
        onChanged: (value) => setState(() {
          tTarget = int.parse(value);
        }),
        decoration: const InputDecoration(
          labelText: "Target",
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
      );
  Widget buildCount() => TextField(
        onChanged: (value) => setState(() {
          tCount = int.parse(value);
        }),
        decoration: const InputDecoration(
          labelText: "Count",
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
      );
}
