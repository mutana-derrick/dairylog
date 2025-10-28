import 'package:hive/hive.dart';
 import '../features/farmers/data/models/farmer_model.dart';

part 'farmer_adapter.g.dart';

@HiveType(typeId: 0)
class FarmerHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String sector;

  @HiveField(4)
  final String cell;

  @HiveField(5)
  final String village;

  FarmerHiveModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.sector,
    required this.cell,
    required this.village,
  });

  // Convert from FarmerModel
  factory FarmerHiveModel.fromModel(Farmer model) {
    return FarmerHiveModel(
      id: model.id,
      name: model.name,
      phone: model.phoneNumber,
      sector: model.sector,
      cell: model.cell,
      village: model.village,
    );
  }

  // Convert to FarmerModel
  Farmer toModel() {
    return Farmer(
      id: id,
      name: name,
      phoneNumber: phone,
      sector: sector,
      cell: cell,
      village: village,
    );
  }
}
