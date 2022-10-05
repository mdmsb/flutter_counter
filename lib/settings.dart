import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasbeeh/main.dart';

import 'package:wakelock/wakelock.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool toggle = false;
  static double vibrateduration = 80;

  @override
  void initState() {
    super.initState();
    _getIntFromSharedPref();
  }

  Future<void> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      vibrateduration = (prefs.getDouble('vibrateduration') ?? 80);
    });
  }

  Future<void> changeSlider(val) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('vibrateduration', val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      // backgroundColor: const Color.fromARGB(255, 63, 30, 30),
      body: Column(
        children: [
          // Card(
          //   elevation: 0,
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: 50,
          // child: Row(
          // children: [
          // const Text("Theme Mode"),
          // Switch(
          //     value: _themeManager.themeMode == ThemeMode.dark,
          //     onChanged: (newValue) {
          //       setState(() {
          //         _themeManager.toggleTheme(newValue);
          //       });
          //     }),
          // ],
          // ),
          //   ),
          // ),
          const SizedBox(height: 10),
          Card(
            elevation: 0,
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: Stack(
                children: [
                  const Text(
                    "Vibration Intensity",
                    style: TextStyle(fontSize: 20),
                  ),
                  Slider(
                    value: vibrateduration,
                    min: 40,
                    max: 140,
                    divisions: 5,
                    label: vibrateduration.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        vibrateduration = value;
                        changeSlider(value);
                        MyHomePageState.vibrateduration = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 0,
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          toggle = !toggle;
                          debugPrint(toggle.toString());

                          toggle ? Wakelock.enable() : Wakelock.disable();
                        });
                      },
                      child: const Text("Toggle Wakelock"),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: Wakelock.enabled,
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        debugPrint(snapshot.toString());
                        final data = snapshot.data;
                        if (data == null) {
                          return Container();
                        }
                        debugPrint("made it");
                        toggle = data ? true : false;
                        return Text('Status : '
                            '${data ? 'Enabled' : 'Disabled'}.');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
