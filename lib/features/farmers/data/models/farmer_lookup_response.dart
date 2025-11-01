import 'farmer_model.dart';

class FarmerLookupResponse {
  final bool success;
  final Farmer? data;
  final String message;
  final MetaData? meta;

  FarmerLookupResponse({
    required this.success,
    this.data,
    required this.message,
    this.meta,
  });

  factory FarmerLookupResponse.fromJson(Map<String, dynamic> json) {
    return FarmerLookupResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? Farmer.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String? ?? '',
      meta: json['meta'] != null
          ? MetaData.fromJson(json['meta'])
          : null,
    );
  }
}

class MetaData {
  final String timestamp;

  MetaData({required this.timestamp});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}