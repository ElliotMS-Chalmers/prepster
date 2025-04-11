import 'package:flutter/material.dart';

import '../../model/entities/pantry_item.dart';
import '../../model/repositories/pantry_repository.dart';

class PantryViewModel extends ChangeNotifier {
  final PantryRepository _repository;
  List<PantryItem> _items = [];

  PantryViewModel(this._repository) {
    _loadItems();
  }

  List<PantryItem> getAllItems() => _items;

  Future<void> _loadItems() async {
    _items = await _repository.getAllItems();
    notifyListeners();
  }

  Future<void> addItem(PantryItem item) async {
    await _repository.addItem(item);
    await _loadItems();
  }

  Future<void> deleteItem(int index) async {
    // await _repository.deleteItem(index);
    _items.removeAt(index);
    notifyListeners();
    await _loadItems();
  }
}

