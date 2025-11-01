import 'user_model.dart';

class UserProfileResponse {
  final bool success;
  final UserModel? data;

  UserProfileResponse({
    required this.success,
    this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
    );
  }
}
