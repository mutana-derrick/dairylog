import 'package:hive/hive.dart';
 
part 'farmer_model.g.dart';

@HiveType(typeId: 20)
class Farmer extends HiveObject {
  @HiveField(0)
  final String id; // unique identifier (could be UUID)

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final String sector;

  @HiveField(4)
  final String cell;

  @HiveField(5)
  final String village;

  Farmer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.sector,
    required this.cell,
    required this.village,
  });

  /// Factory constructor to create Farmer from JSON (API)
  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      sector: json['sector'] as String,
      cell: json['cell'] as String,
      village: json['village'] as String,
    );
  }

  /// Converts Farmer to JSON (for API or storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'sector': sector,
      'cell': cell,
      'village': village,
    };
  }
}
