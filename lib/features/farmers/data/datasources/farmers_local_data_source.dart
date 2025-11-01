import 'package:hive/hive.dart';
import '../../../../core/constants/hive_boxes.dart';
import '../models/farmer_model.dart';

abstract class FarmersLocalDataSource {
  Future<List<Farmer>> getFarmers(); // ✅ Changed from getAllFarmers
  Future<void> saveFarmer(Farmer farmer); // ✅ Changed from addFarmer
  Future<void> saveFarmers(List<Farmer> farmers); // ✅ Added for bulk save
  Future<Farmer?> getFarmerByPhone(String phoneNumber);
  Future<void> updateFarmer(Farmer farmer);
  Future<void> deleteFarmer(int id); // ✅ Changed String to int
}

class FarmersLocalDataSourceImpl implements FarmersLocalDataSource {
  FarmersLocalDataSourceImpl(); // ✅ No constructor parameters

  Box<Farmer> get _farmersBox => Hive.box<Farmer>(HiveBoxes.farmersBox);

  @override
  Future<List<Farmer>> getFarmers() async {
    return _farmersBox.values.toList();
  }

  @override
  Future<void> saveFarmer(Farmer farmer) async {
    await _farmersBox.put(farmer.id, farmer);
  }

  @override
  Future<void> saveFarmers(List<Farmer> farmers) async {
    for (var farmer in farmers) {
      await _farmersBox.put(farmer.id, farmer);
    }
  }

  @override
  Future<Farmer?> getFarmerByPhone(String phoneNumber) async {
    try {
      return _farmersBox.values.firstWhere(
        (farmer) => farmer.phoneNumber == phoneNumber,
      );
    } on StateError {
      return null;
    }
  }

  @override
  Future<void> updateFarmer(Farmer farmer) async {
    await _farmersBox.put(farmer.id, farmer);
  }

  @override
  Future<void> deleteFarmer(int id) async {
    await _farmersBox.delete(id);
  }
}