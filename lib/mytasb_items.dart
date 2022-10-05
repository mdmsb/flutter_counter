import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tasbeeh/mytasblistedit.dart';

class MyTasbList extends StatefulWidget {
  final int tkey;
  final String title;
  final String text;
  final int target;
  final int count;
  final dynamic onDeleteData;

  const MyTasbList({
    super.key,
    required this.tkey,
    required this.title,
    required this.text,
    required this.target,
    required this.count,
    required this.onDeleteData,
  });

  @override
  State<MyTasbList> createState() => _MyTasbListState();
}

class _MyTasbListState extends State<MyTasbList> {
  final tBox = Hive.box('tasbeehBox');
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text(
            "${widget.title} ${widget.text} ${widget.target} ${widget.count}"),
        trailing: Wrap(
          spacing: 6,
          children: [
            EditButton(tkey: widget.tkey, tBox: tBox),
            DeleteButton(tkey: widget.tkey, onDeleteData: widget.onDeleteData),
          ],
        ),
      ),
    );
  }
}

class EditButton extends StatefulWidget {
  const EditButton({super.key, required this.tkey, this.tBox});

  final int tkey;
  final dynamic tBox;

  @override
  State<EditButton> createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  late String valueText;

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          debugPrint(widget.tkey.toString());
          showDialog(
              context: context,
              builder: (context) {
                return MyTasbFormEdit(update: update, tkey: widget.tkey);
              });

          // _myBox.put(tas, "value");
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       title: const Text("Tasbeeh"),
          //       content: TextField(
          //         controller: TextEditingController()
          //           ..text = widget.tBox
          //               .get(
          //                 widget.tkey,
          //               )
          //               .text,
          //         maxLines: null,
          //         decoration:
          //             const InputDecoration(hintText: "Enter new Tasbeeh"),
          //         onChanged: (value) {
          //           valueText = value;
          //         },
          //       ),
          //       // content: "Tasbeehyaat.buildTextField()",
          //       actions: [
          //         TextButton(
          //             onPressed: () {
          //               debugPrint('pressed cancel');
          //               Navigator.pop(context);
          //             },
          //             child: const Text('Cancel')),
          //         ElevatedButton(
          //             onPressed: () {
          //               debugPrint('pressed Submit $valueText');
          //               // writeData(valueText);
          //               setState(() {
          //                 widget.tBox.put(widget.tkey, valueText);
          //               });
          //               Navigator.pop(context);
          //             },
          //             child: const Text('Add Tasbeeh')),
          //       ],
          //     );
          //   },
          // );
        },
      ),
    );
  }
}

class DeleteButton extends StatefulWidget {
  const DeleteButton({
    super.key,
    required this.tkey,
    required this.onDeleteData,
  });
  final int tkey;
  final dynamic onDeleteData;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          debugPrint(widget.tkey.toString());
          setState(() {
            widget.onDeleteData(widget.tkey);
          });
        },
      ),
    );
  }
}
