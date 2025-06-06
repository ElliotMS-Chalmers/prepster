import 'package:prepster/model/entities/medical_item.dart';
import 'package:prepster/model/repositories/inventory_repository.dart';
import 'package:prepster/ui/viewmodels/inventory_view_model.dart';

class MedicalViewModel extends InventoryViewModel<MedicalItem> {
  MedicalViewModel(InventoryRepository repository) : super(repository);

  Future<void> addItem({
    required String name,
    int? amount,
    DateTime? expirationDate,
    bool? excludeFromDateTracker,
  }) async {
    await repository.addItem(
      itemType: ItemType.medicalItem,
      name: name,
      expirationDate: expirationDate,
      excludeFromDateTracker: excludeFromDateTracker,
      amount: amount,
    );
    await loadItems();
  }

  Future<void> updateItem({
    required String id, //Identifier that will be used for service
    required ItemType itemType,
    required String name,
    int? amount,
    DateTime? expirationDate,
    bool? excludeFromDateTracker,
  }) async {
    await repository.updateItem(
      id: id,
      itemType: itemType,
      name: name,
      amount: amount,
      expirationDate: expirationDate,
      excludeFromDateTracker: excludeFromDateTracker,
    );
    await loadItems();
  }
}
