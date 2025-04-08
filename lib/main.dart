import 'package:flutter/material.dart';
import 'package:prepster/equipment.dart';
import 'package:prepster/medical.dart';
import 'package:prepster/pantry.dart';
import 'package:prepster/resources.dart';
import 'settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MyHomePage(title: 'Flutter Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final _pageOptions = [
    PantryPage(),
    MedicalPage(),
    EquipmentPage(),
    ResourcesPage(),
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addPantryItem() {
    setState(() {
      //do something
      UnimplementedError("implement add pantry item");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _addPantryItem,
        tooltip: 'Add product to pantry',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Pantry'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'Medical'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: "Equipment"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Resources"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
