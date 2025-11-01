import 'farmer_model.dart';

class FarmerResponse {
  final bool success;
  final Farmer? data;
  final String message;

  FarmerResponse({
    required this.success,
    this.data,
    required this.message,
  });

  factory FarmerResponse.fromJson(Map<String, dynamic> json) {
    return FarmerResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null 
          ? Farmer.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String? ?? '',
    );
  }
}