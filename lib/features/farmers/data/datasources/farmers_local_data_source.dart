import 'package:hive/hive.dart';
import '../models/farmer_model.dart';


abstract class FarmersLocalDataSource {
  Future<List<Farmer>> getAllFarmers();
  Future<void> addFarmer(Farmer farmer);
  Future<Farmer?> getFarmerByPhone(String phoneNumber);
  Future<void> updateFarmer(Farmer farmer);
  Future<void> deleteFarmer(String id);
}

class FarmersLocalDataSourceImpl implements FarmersLocalDataSource {
  final Box<Farmer> farmersBox;

  FarmersLocalDataSourceImpl(this.farmersBox);

  @override
  Future<void> addFarmer(Farmer farmer) async {
    await farmersBox.put(farmer.id, farmer);
  }

  @override
  Future<void> deleteFarmer(String id) async {
    await farmersBox.delete(id);
  }

  @override
  Future<List<Farmer>> getAllFarmers() async {
    return farmersBox.values.toList();
  }

  @override
  Future<Farmer?> getFarmerByPhone(String phoneNumber) async {
    try {
      return farmersBox.values.firstWhere((farmer) => farmer.phoneNumber == phoneNumber);
    } on StateError {
      return null;
    }
  }

  @override
  Future<void> updateFarmer(Farmer farmer) async {
    await farmersBox.put(farmer.id, farmer);
  }
}
