import 'package:flutter/material.dart';
import 'package:prepster/ui/viewmodels/dashboard_view_model.dart';

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
import 'package:prepster/ui/viewmodels/settings_view_model.dart';

import 'package:prepster/utils/theme_provider.dart';
import 'package:prepster/utils/logger.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.level = Level.all;
  logger.i("Log level set to ${Logger.level.name.toUpperCase()}");
  await EasyLocalization.ensureInitialized();
  SettingsRepository settings = SettingsRepository(SettingsService.instance);
  await settings.initializeCache();

  runApp(
    EasyLocalization(
      supportedLocales: settings.getLocales(),
      path: settings.getTranslationsPath(),
      fallbackLocale: settings.getFallbackLocale(),
      startLocale: await settings.getPreferredLocale(),
      //startLocale: Locale('sv'), // for testing swap out line above with this
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


    // Due to initialization of EasyLocalization,
    // app_title and homepage_title might not load right away when
    // the app is run, but will load correctly when rebuild is triggered.
    // The following warnings at start are expected and can be safely ignored:
    // [🌎 Easy Localization] [WARNING] Localization key [app_title] not found
    // [🌎 Easy Localization] [WARNING] Localization key [home_page_title] not found

    return MaterialApp(
      debugShowCheckedModeBanner: false, // disable debug banner in emulator
      title: 'app_title'.tr(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PantryViewModel(PantryRepository())),
        ChangeNotifierProvider(create: (_) => SettingsViewModel(SettingsRepository(SettingsService.instance)), child: SettingsPage(),),
        ChangeNotifierProxyProvider2<PantryViewModel, SettingsViewModel,DashboardViewModel>(
          create: (_) => DashboardViewModel(null, null),
          update: (_, pantryVM, settingsVM,previousDashboardVM) => DashboardViewModel(
            pantryVM,
            settingsVM,
          ),
        ),
        // Add more view models here as needed
      ],
      child: HomePage(title: 'home_page_title'.tr()),
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
    SettingsPage(),
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
        tooltip: 'tooltip_add_pantry_item'.tr(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'bottom_nav_home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory),
            label: 'bottom_nav_pantry'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.medication),
            label: 'bottom_nav_medical'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.build),
            label: "bottom_nav_equipment".tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info),
            label: "bottom_nav_resources".tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: "bottom_nav_settings".tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

