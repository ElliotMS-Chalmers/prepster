import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:prepster/utils/logger.dart';

class ResourcesRepository {
  List<List<String>> data = []; // Each item will be [name, filepath]
  Set<String> _manifestKeys = {}; // filtered keys from AssetManifest

  // Private constructor
  ResourcesRepository._();

  // Static factory method to create and initialize
  static Future<ResourcesRepository> create(String language) async {
    final repository = ResourcesRepository._();
    await repository._initializeAndFilterManifest();
    await repository._loadResourceFiles(language);
    //logger.i('ResourcesRepository initialized with language: ${language}');
    return repository;
  }

  Future<void> changeLanguage(String language) async {
    await _loadResourceFiles(language);
    //logger.i('ResourcesRepository language changed to: $language');
  }

  Future<void> _initializeAndFilterManifest() async {
    try {
      // Load the asset manifest and store only keys from assets/resources/
      final Map<String, dynamic> manifestMap =
          json.decode(await rootBundle.loadString('AssetManifest.json'))
              as Map<String, dynamic>;
      _manifestKeys =
          manifestMap.keys
              .where((key) => key.startsWith('assets/resources/'))
              .toSet();
      //logger.i('Loaded asset manifest with ${_manifestKeys.length} keys');
    } catch (e) {
      //logger.e('Error loading asset manifest: $e');
    }
  }

  Future<void> _loadResourceFiles(String language) async {
    try {
      // Filter for PDF files in resources folder with the specified language
      final filePaths =
          _manifestKeys
              .where((String key) => key.contains('_${language}_'))
              .toList();

      // Populate the data list with lists of [name, filepath]
      data = filePaths.map((path) => [_extractFileName(path), path]).toList();
      //logger.i('Loaded ${data.length} resource files for language: $language');
    } catch (e) {
      //logger.e('Error loading resource files: $e');
    }
  }

  String _extractFileName(String filePath) {
    final fileName = filePath.split('/').last;
    String newName = fileName
        .replaceFirst(RegExp(r'^\d+_.._'), '')
        .replaceAll('.pdf', '')
        .replaceAll('_', ' ');
    //logger.i('Extracted file name: $newName from path: $filePath');
    return newName;
  }
}
