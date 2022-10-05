import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasbeeh/listmodel.dart';

class MyTasbFormEdit extends StatefulWidget {
  final Function update;
  final dynamic tkey;
  const MyTasbFormEdit({super.key, required this.update, this.tkey});

  @override
  State<MyTasbFormEdit> createState() => _MyTasbFormEditState();
}

class _MyTasbFormEditState extends State<MyTasbFormEdit> {
  final tBox = Hive.box('tasbeehBox');

  late String tTitle = tBox.get(widget.tkey).title;
  late String tText = tBox.get(widget.tkey).text;
  late int tTarget = tBox.get(widget.tkey).target;
  late int tCount = tBox.get(widget.tkey).count;

  void editData() {
    setState(() {
      tBox.put(
          widget.tkey,
          TasbeehModel(
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
              editData();
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

  Widget buildTitle() => TextFormField(
        initialValue: tTitle,
        onChanged: (value) => setState(() => tTitle = value),
        decoration: const InputDecoration(
          labelText: "Title",
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
      );
  Widget buildText() => TextFormField(
        initialValue: tText,
        onChanged: (value) => setState(() => tText = value),
        decoration: const InputDecoration(
          labelText: "Text",
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
      );
  Widget buildTarget() => TextFormField(
        initialValue: tTarget.toString(),
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
  Widget buildCount() => TextFormField(
        initialValue: tCount.toString(),
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
