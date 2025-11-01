import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 10)
class UserModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String? location;

  @HiveField(5)
  final String? collectionName;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final String? accessToken;

  @HiveField(8)
  final String? refreshToken;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.location,
    this.collectionName,
    this.createdAt,
    this.accessToken,
    this.refreshToken,
  });

  // ✅ ROBUST: Handles both String and int from API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseInt(json['id']), // ✅ Safe parsing
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      location: json['location'] as String?,
      collectionName: json['collection_name'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  // ✅ Helper method to safely parse int from dynamic
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw FormatException('Cannot parse $value to int');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'location': location,
        'collection_name': collectionName,
        'createdAt': createdAt?.toIso8601String(),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };

  UserModel copyWithTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    return UserModel(
      id: id,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      location: location,
      collectionName: collectionName,
      createdAt: createdAt,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}