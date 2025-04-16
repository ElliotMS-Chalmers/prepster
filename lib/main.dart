import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:prepster/ui/viewmodels/pantry_view_model.dart';
import 'package:provider/provider.dart';

import 'model/repositories/pantry_repository.dart';

import 'ui/pages/equipment.dart';
import 'ui/pages/medical.dart';
import 'ui/pages/pantry.dart';
import 'ui/pages/resources.dart';
import 'ui/pages/settings.dart';
import 'ui/widgets/dialog_popup.dart';

void main() {
  Logger.level = Level.all;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prepster',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.light),
      ),
      home: ChangeNotifierProvider(
        create: (context) => PantryViewModel(PantryRepository()),
        child: const HomePage(title: 'Home Page'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void _addPantryItem(String name, String calories100g, String weightKg, DateTime? date) {
    final pantryViewModel = Provider.of<PantryViewModel>(context, listen: false);
    pantryViewModel.addItem(name: name, calories100g: double.parse(calories100g), weightKg: double.parse(weightKg), expirationDate: date);
  }

  void _displayItemPopup() {
    DateTime? selectedDate;
    showDialog(
      context: context,
      builder: (_) => NewItemDialogPopup(
        selectedDate: selectedDate,
        onSubmit: (name, calories, weight, date) {
          _addPantryItem(name, calories, weight, date);
          setState(() {
            selectedDate = date;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _displayItemPopup,
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