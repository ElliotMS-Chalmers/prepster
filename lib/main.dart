import 'package:flutter/material.dart';
import 'package:prepster/equipment.dart';
import 'package:prepster/medical.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/pantry.dart';
import 'package:prepster/resources.dart';
import 'package:provider/provider.dart';
import 'model/repositories/pantry_repository.dart';
import 'settings.dart';

void main() {
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
        create: (context) => PantryRepository(),
        child: const HomePage(title: 'Home Page'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final TextEditingController _textController3 = TextEditingController();

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
    final pantryRepository = Provider.of<PantryRepository>(context, listen: false);
    pantryRepository.addItem(PantryItem(name: name, calories100g: double.parse(calories100g), weightKg: double.parse(weightKg), expirationDate: date));
  }

  void _displayItemPopup() {
    DateTime? selectedDate;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter item info'),
          content: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textController1,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _textController2,
                decoration: InputDecoration(labelText: 'Calories per 100g'),
              ),
              TextField(
                controller: _textController3,
                decoration: InputDecoration(labelText: 'Weight in kg'),
              ),
              TextFormField(
                controller: TextEditingController(
                  text: selectedDate == null
                      ? ''
                      : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                ),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Expiration Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 2),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Ensure all fields are filled out and that a date is selected
                if (_textController1.text.isNotEmpty &&
                    _textController2.text.isNotEmpty &&
                    _textController3.text.isNotEmpty &&
                    selectedDate != null) {
                  _addPantryItem(
                    _textController1.text,
                    _textController2.text,
                    _textController3.text,
                    selectedDate!,
                  );
                  Navigator.pop(context);
                } else {
                  // Show an error message if fields are missing
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields and select a date')),
                  );
                }},
              child: Text('Submit'),
            ),
          ],
        );},
    );
  }

    @override
    void dispose() {
      _textController1.dispose();
      _textController2.dispose();
      _textController3.dispose();
      super.dispose();
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