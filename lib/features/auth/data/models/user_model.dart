import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 10)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String? accessToken;

  @HiveField(5)
  final String? refreshToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.accessToken,
    this.refreshToken,
  });

  // From JSON (for API responses that include user info)
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        accessToken: json['accessToken'] as String?,
        refreshToken: json['refreshToken'] as String?,
      );

  // To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };

  // Copy with tokens
  UserModel copyWithTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}