import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbeeh/theme/theme_constant.dart';
import 'settings.dart';
import 'package:vibration/vibration.dart';
import 'tasbeeh.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myBox');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static const appTitle = 'Tasbeeh';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp.appTitle,
      theme: darkTheme,
      home: const MyHomePage(title: MyApp.appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _count = 0;
  late int valueInt;

  static double vibrateduration = 100;
  bool? _isChecked = false;
  int _delayclicks = 0;

  @override
  void initState() {
    super.initState();
    _getIntFromSharedPref();
  }

  Future<void> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = (prefs.getInt('_count') ?? 0);
      _isChecked = (prefs.getBool('_isChecked') ?? false);
    });
  }

  Future<void> incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = (prefs.getInt('_count') ?? 0) + 1;
      prefs.setInt('_count', _count);
    });
    if (_isChecked == true) {
      Vibration.vibrate(duration: vibrateduration.toInt());
    }
  }

  Future<void> editCounter(int val) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = val;
      prefs.setInt('_count', val);
    });
  }

  Future<void> resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = 0;
      prefs.setInt('_count', 0);
    });
  }

  Future<void> setVibrate(vibrateState) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('_isChecked', vibrateState);
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
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: Colors.black)),
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
                ElevatedButton(
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
                                    debugPrint("error1");
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
          ),
          Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("vibrate check is $_isChecked");
                  incrementCounter();
                },
                onLongPress: () {
                  debugPrint("Long pressed");
                  autoClick();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(24),
                  minimumSize: const Size(200, 40),
                  backgroundColor: Colors.red[900],
                ),
                child: Text(
                  '$_count',
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const NavDraw(),
    );
  }
}

class NavDraw extends StatefulWidget {
  const NavDraw({super.key});

  @override
  State<NavDraw> createState() => _NavDrawState();
}

class _NavDrawState extends State<NavDraw> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            // decoration: BoxDecoration(
            //   // color: Colors.blue,
            // ),
            child: Text(
              'الحمد لله ربّ العالمين',
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.right,
            ),
          ),
          ListTile(
            title: const Text('Tasbihyaat'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Tasbeeh()),
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
