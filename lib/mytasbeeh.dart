import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasbeeh/listmodel.dart';
import 'package:tasbeeh/mytasbcount.dart';

class Tasbeehyaat extends StatefulWidget {
  const Tasbeehyaat({super.key});

  @override
  State<Tasbeehyaat> createState() => _TasbeehyaatState();
}

class _TasbeehyaatState extends State<Tasbeehyaat> {
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
  }

  void deleteData(id) {
    setState(() {
      tBox.delete(id);
    });
  }

  void editData(id) {
    setState(() {
      tBox.put(
          id,
          TasbeehModel(
              title: tTitle, text: tText, target: tTarget, count: tCount));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasbeehyaat"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [for (var tkey in tBox.keys) buildTasbeehItems(tkey)],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            tTitle = "";
            tText = "";
            tTarget = 0;
            tCount = 0;
          });
          showDialog(
              context: context,
              builder: (context) {
                return buildForm(); // BUILD NEW FORM
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //
  // BUILD NEW FORM
  //
  Widget buildForm() => AlertDialog(
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
                setState(() {
                  writeData();
                });
                Navigator.pop(context);
              },
              child: const Text('Add Tasbeeh')),
        ],
      );

  //
  // BUILD EDIT FORM
  //
  Widget buildEditForm(tkey) => AlertDialog(
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
                setState(() {
                  editData(tkey);
                });
                Navigator.pop(context);
              },
              child: const Text('Add Tasbeeh')),
        ],
      );

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

  Widget buildTasbeehItems(tkey) => Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                debugPrint(tkey.toString());
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TasbCount(tkey: tkey)),
                );
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Title: ",
                        style: TextStyle(color: Colors.orange),
                      ),
                      Text(
                        "${tBox.get(tkey).title}",
                        style: TextStyle(color: Colors.lime[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        "Text: ",
                        style: TextStyle(color: Colors.orange),
                      ),
                      Text(
                        "${tBox.get(tkey).text}",
                        style: TextStyle(color: Colors.lime[800]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    color: const Color(0xff212121),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Target: ${tBox.get(tkey).target}",
                            style: const TextStyle(color: Colors.lightBlue),
                          ),
                          Text(
                            "Count: ${tBox.get(tkey).count}",
                            style: const TextStyle(color: Colors.lightBlue),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
                        debugPrint(tkey.toString());
                        setState(() {
                          tTitle = tBox.get(tkey).title;
                          tText = tBox.get(tkey).text;
                          tTarget = tBox.get(tkey).target;
                          tCount = tBox.get(tkey).count;
                        });
                        showDialog(
                            context: context,
                            builder: (context) {
                              return buildEditForm(tkey);
                            });
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
                      color: Colors.red[800],
                      icon: const Icon(Icons.delete),
                      iconSize: 18,
                      onPressed: () {
                        debugPrint(tkey.toString());
                        setState(() {
                          deleteData(tkey);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
