import 'package:hive/hive.dart';

part 'milk_record_model.g.dart';

@HiveType(typeId: 30)
class MilkRecord extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int farmerId;

  @HiveField(2)
  final String farmerName;

  @HiveField(3)
  final String farmerPhone;

  @HiveField(4)
  final double liters;

  @HiveField(5)
  final double pricePerLiter;

  @HiveField(6)
  final DateTime recordedAt;

  MilkRecord({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmerPhone,
    required this.liters,
    required this.pricePerLiter,
    required this.recordedAt,
  });

  // ✅ Calculate total amount on frontend
  double get totalAmount => liters * pricePerLiter;

  // ✅ From API list response
  factory MilkRecord.fromJson(Map<String, dynamic> json) {
    return MilkRecord(
      id: json['recordId'] is int
          ? json['recordId']
          : int.parse(json['recordId'].toString()),
      farmerId: json['farmer']['id'] is int
          ? json['farmer']['id']
          : int.parse(json['farmer']['id'].toString()),
      farmerName: json['farmer']['name'] as String? ?? '',
      farmerPhone: json['farmer']['phoneNumber'] as String? ?? '',
      liters: (json['liters'] as num).toDouble(),
      pricePerLiter: (json['price_per_liter'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );
  }

  // ✅ To API
  Map<String, dynamic> toJson() {
    return {
      'recordId': id,
      'liters': liters,
      'price_per_liter': pricePerLiter,
      'recordedAt': recordedAt.toIso8601String(),
      'farmer': {
        'id': farmerId,
        'name': farmerName,
        'phoneNumber': farmerPhone,
      },
    };
  }
}
