import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'model/repositories/pantry_repository.dart';
import 'model/repositories/settings_repository.dart';
import 'model/services/settings_service.dart';

import 'package:prepster/ui/pages/dashboard.dart';
import 'package:prepster/ui/pages/equipment.dart';
import 'package:prepster/ui/pages/medical.dart';
import 'package:prepster/ui/pages/pantry.dart';
import 'package:prepster/ui/pages/resources.dart';
import 'package:prepster/ui/pages/settings.dart';
import 'package:prepster/ui/widgets/dialog_popup.dart';
import 'package:prepster/ui/viewmodels/pantry_view_model.dart';

import 'package:prepster/utils/theme_provider.dart';
import 'package:prepster/utils/logger.dart';
import 'package:logger/logger.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.level = Level.all;
  logger.i("Log level set to ${Logger.level.name.toUpperCase()}");
  await EasyLocalization.ensureInitialized();
  SettingsRepository settings = SettingsRepository(SettingsService.instance);
  List<Locale> locales =
      settings
          .getAvailableLanguages()
          .map((langCode) => Locale(langCode))
          .toList();
  String fallbackLocale = settings.getFallbackLanguage();

  Locale preferredLocale = await _getPreferredLocale(settings);

  runApp(
    EasyLocalization(
      supportedLocales: locales,
      path: 'assets/translations',
      fallbackLocale: Locale(fallbackLocale),
      startLocale: preferredLocale,
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Prepster',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
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
    DashboardPage(),
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

  void _addPantryItem(
    String name,
    String calories100g,
    String weightKg,
    DateTime? date,
  ) {
    final pantryViewModel = Provider.of<PantryViewModel>(
      context,
      listen: false,
    );
    pantryViewModel.addItem(
      name: name,
      calories100g: double.parse(calories100g),
      weightKg: double.parse(weightKg),
      expirationDate: date,
    );
  }

  void _displayItemPopup() {
    DateTime? selectedDate;
    showDialog(
      context: context,
      builder:
          (_) => NewItemDialogPopup(
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Pantry'),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'Medical'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: "Equipment"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Resources"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

Future<Locale> _getPreferredLocale(SettingsRepository settingsRepo) async {
  // Check if a language is set in settingsRepo
  String? savedLanguageCode = await settingsRepo.getSelectedLanguage();
  if (savedLanguageCode != null) {
    logger.d("Saved language: $savedLanguageCode");
    return Locale(savedLanguageCode);
  }

  // If not set in settingsRepo, read from device (phone) settings
  Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
  String deviceLanguageCode = deviceLocale.languageCode;

  // Check if the device language is suported
  if (settingsRepo.getAvailableLanguages().contains(deviceLanguageCode)) {
    logger.d("Device language: $deviceLanguageCode");
    return Locale(deviceLanguageCode);
  }

  // If the phone language is not supported (or could not be read), use fallback
  logger.d("Using fallback language: ${settingsRepo.getFallbackLanguage()}");
  return Locale(settingsRepo.getFallbackLanguage());
}