import 'package:hive/hive.dart';

part 'milk_record_model.g.dart';

@HiveType(typeId: 30)
class MilkRecord extends HiveObject {
  @HiveField(0)
  final String farmerPhoneNumber;

  @HiveField(1)
  final double quantity; // in liters

  @HiveField(2)
  final double price; // price per liter or total price

  @HiveField(3)
  final DateTime date;

  MilkRecord({
    required this.farmerPhoneNumber,
    required this.quantity,
    required this.price,
    required this.date,
  });
}
