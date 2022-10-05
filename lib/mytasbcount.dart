import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbeeh/listmodel.dart';
import 'package:vibration/vibration.dart';

class TasbCount extends StatefulWidget {
  final int tkey;
  const TasbCount({super.key, required this.tkey});

  @override
  State<TasbCount> createState() => _TasbCountState();
}

class _TasbCountState extends State<TasbCount> {
  final tBox = Hive.box('tasbeehBox');
  static double vibrateduration = 80;
  bool? _isChecked = false;
  int _delayclicks = 0;
  int _count = 0;
  late int valueInt;

  String tTitle = "";
  String tText = "";
  int tTarget = 0;

  @override
  void initState() {
    super.initState();
    _count = tBox.get(widget.tkey).count;
    tTitle = tBox.get(widget.tkey).title;
    tText = tBox.get(widget.tkey).text;
    tTarget = tBox.get(widget.tkey).target;
    _getIntFromSharedPref();
  }

  Future<void> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vibrateduration = (prefs.getDouble('vibrateduration') ?? 80);
    });
  }

  void incrementCounter() {
    setState(() {
      _count++;
      tBox.put(
          widget.tkey,
          TasbeehModel(
              title: tTitle, text: tText, target: tTarget, count: _count));
      if (_isChecked == true) {
        Vibration.vibrate(duration: vibrateduration.toInt());
      }
      debugPrint("increement");
    });
  }

  Future<void> setVibrate(vibrateState) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('_isChecked', vibrateState);
    });
  }

  Future<void> editCounter(int val) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = val;
      prefs.setInt('_count', val);
    });
  }

  Future<void> startCount() async {
    debugPrint("looping $_delayclicks");
    if (_delayclicks != 0) {
      while (_delayclicks != 0) {
        debugPrint("looping");
        incrementCounter();
        await Future.delayed(Duration(seconds: _delayclicks));
      }
    }
  }

  Future<void> autoClick() async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AlertDialog(
                title: const Text('Auto Clicks'),
                content: Column(
                  verticalDirection: VerticalDirection.down,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Add seconds to delay and auto click."),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            debugPrint("Decrese secs");
                            if (_delayclicks != 0) {
                              setState(() {
                                --_delayclicks;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 18.0),
                          iconSize: 32.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text("$_delayclicks"),
                        IconButton(
                          onPressed: () {
                            debugPrint("Increse secs");
                            setState(() {
                              ++_delayclicks;
                            });
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 18.0),
                          iconSize: 32.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ],
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
                        debugPrint('pressed Reset');
                        startCount();
                        Navigator.pop(context);
                      },
                      child: const Text('Start')),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasbiyaat Count"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 109, 71, 71))),
                    title: const Text(
                      "Vibrate",
                    ),
                    value: _isChecked,
                    onChanged: (newValue) {
                      debugPrint("Checked $newValue");
                      setState(() {
                        _isChecked = newValue;
                        setVibrate(newValue);
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                if (_delayclicks != 0)
                  const SizedBox(
                    width: 10,
                  ),
                if (_delayclicks != 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _delayclicks = 0;
                      });
                    },
                    child: const Text("Stop Autoclicks"),
                  ),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Edit Counter'),
                              content: TextField(
                                controller: TextEditingController()
                                  ..text = _count.toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration:
                                    const InputDecoration(hintText: "Value"),
                                onChanged: (value) {
                                  // var n = num.tryParse(value);
                                  // var intval = int.parse(value);

                                  try {
                                    var intval = int.parse(value);
                                    valueInt = intval;
                                  } on Exception catch (exception) {
                                    debugPrint("error1 $exception");
                                    valueInt = 0;
                                  } catch (error) {
                                    debugPrint("error2");
                                  }
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
                                      debugPrint('pressed Reset');
                                      editCounter(valueInt);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Edit Count')),
                              ],
                            );
                          });
                    },
                    child: const Text('Edit Count')),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      debugPrint("vibrate check is $_isChecked");
                      incrementCounter();
                    },
                    onLongPress: () {
                      debugPrint("Long pressed");
                      autoClick();
                    },
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tTitle,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            tText,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '$_count',
                              style: const TextStyle(
                                fontSize: 70,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Target : $tTarget",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
