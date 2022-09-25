import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Tasbeeh';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = _getIntFromSharedPref();

  Future<int> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('_count');
    if (count == null) {
      return 0;
    }
    return count;
  }

  Future<void> incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count++;
    });
    await prefs.setInt('_count', _count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        color: Colors.black,
        child: Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                incrementCounter();
              },
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(24),
                  minimumSize: const Size(200, 40),
                  backgroundColor: const Color.fromARGB(255, 232, 0, 0)),
              child: Text(
                '$_count',
                style: const TextStyle(fontSize: 50),
              ),
            ),
          ),
        ),
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
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
