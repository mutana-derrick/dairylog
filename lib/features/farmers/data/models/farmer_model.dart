import 'package:hive/hive.dart';

part 'farmer_model.g.dart';

@HiveType(typeId: 20)
class Farmer extends HiveObject {
  @HiveField(0)
  final int id; 

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

  @HiveField(6)
  final DateTime? createdAt;

  Farmer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.sector,
    required this.cell,
    required this.village,
    this.createdAt,
  });

  // ✅ From API response
  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: _parseInt(json['id']),
      name: json['farmer_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      sector: json['sector'] as String? ?? '',
      cell: json['cell'] as String? ?? '',
      village: json['village'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // ✅ Safe int parsing
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw FormatException('Cannot parse $value to int');
  }

  // ✅ To API request
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmer_name': name,
      'phone_number': phoneNumber,
      'sector': sector,
      'cell': cell,
      'village': village,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // ✅ Copy with
  Farmer copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? sector,
    String? cell,
    String? village,
    DateTime? createdAt,
  }) {
    return Farmer(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      sector: sector ?? this.sector,
      cell: cell ?? this.cell,
      village: village ?? this.village,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}