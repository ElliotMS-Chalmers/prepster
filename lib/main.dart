import 'package:flutter/material.dart';
import 'package:prepster/model/entities/inventory_item.dart';
import 'package:prepster/model/repositories/inventory_repository.dart';
import 'package:prepster/model/services/json_storage_service.dart';
import 'package:prepster/model/services/pantry_json_storage_service.dart';
import 'package:prepster/ui/viewmodels/dashboard_view_model.dart';

import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'model/entities/medical_item.dart';
import 'model/entities/pantry_item.dart';
import 'model/repositories/settings_repository.dart';
import 'model/services/medical_json_storage_service.dart';
import 'model/services/settings_service.dart';

import 'package:prepster/ui/pages/dashboard/dashboard.dart';
import 'package:prepster/ui/pages/inventory/inventory.dart';
import 'package:prepster/ui/pages/resources.dart';
import 'package:prepster/ui/pages/settings.dart';
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
  final themeProvider = ThemeProvider(settings);
  await themeProvider.loadTheme();

  runApp(
    EasyLocalization(
      supportedLocales: settings.getLocales(),
      path: settings.getTranslationsPath(),
      fallbackLocale: settings.getFallbackLocale(),
      startLocale: await settings.getPreferredLocale(),
      //startLocale: Locale('sv'), // for testing swap out line above with this
      child: ChangeNotifierProvider(
        create: (_) => themeProvider,
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
        ChangeNotifierProvider(create: (_) => PantryViewModel(InventoryRepository<PantryItem>(PantryJsonStorageService.instance))),
        ChangeNotifierProvider(create: (_) => SettingsViewModel(SettingsRepository(SettingsService.instance)), child: SettingsPage(),),
        ChangeNotifierProxyProvider2<PantryViewModel, SettingsViewModel, DashboardViewModel>(
          create: (_) => DashboardViewModel(null, null),
          update: (_, pantryVM, settingsVM, previousDashboardVM) => DashboardViewModel(
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
    InventoryPage(),
    //MedicalPage(),
    //EquipmentPage(),
    ResourcesPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'bottom_nav_home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory),
            label: 'bottom_nav_inventory'.tr(),
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
        onTap: _onItemTapped,
      ),
    );
  }
}

