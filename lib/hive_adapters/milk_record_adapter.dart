import 'package:hive/hive.dart';
import '../features/milk_records/data/models/milk_record_model.dart';

part 'milk_record_adapter.g.dart';

@HiveType(typeId: 1)
class MilkRecordHiveModel extends HiveObject {
  // @HiveField(0)
  // final String id;

  // @HiveField(1)
  // final String farmerId;

  // @HiveField(2)
  // final String farmerName;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final double quantity; // liters

  @HiveField(5)
  final double price;

  @HiveField(6)
  final DateTime date;

  MilkRecordHiveModel({
    // required this.id,
    // required this.farmerId,
    // required this.farmerName,
    required this.phone,
    required this.quantity,
    required this.price,
    required this.date,
  });

  // Convert from MilkRecordModel
  factory MilkRecordHiveModel.fromModel(MilkRecord model) {
    return MilkRecordHiveModel(
      // id: model.id,
      // farmerId: model.farmerId,
      // farmerName: model.farmerName,
      phone: model.farmerPhoneNumber,
      quantity: model.quantity,
      price: model.price,
      date: model.date,
    );
  }

  // Convert to MilkRecordModel
  MilkRecord toModel() {
    return MilkRecord(
      // id: id,
      // farmerId: farmerId,
      // farmerName: farmerName,
      farmerPhoneNumber: phone,
      quantity: quantity,
      price: price,
      date: date,
    );
  }
}
