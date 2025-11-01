class MilkRecordResponse {
  final bool success;
  final MilkRecordData? data;
  final String message;

  MilkRecordResponse({
    required this.success,
    this.data,
    required this.message,
  });

  factory MilkRecordResponse.fromJson(Map<String, dynamic> json) {
    return MilkRecordResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? MilkRecordData.fromJson(json['data'])
          : null,
      message: json['message'] as String? ?? '',
    );
  }
}

class MilkRecordData {
  final int id;
  final int farmerId;
  final double liters;
  final double pricePerLiter;
  final DateTime recordedAt;
  final FarmerInfo? farmer;

  MilkRecordData({
    required this.id,
    required this.farmerId,
    required this.liters,
    required this.pricePerLiter,
    required this.recordedAt,
    this.farmer,
  });

  factory MilkRecordData.fromJson(Map<String, dynamic> json) {
    return MilkRecordData(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      farmerId: json['farmer_id'] is int
          ? json['farmer_id']
          : int.parse(json['farmer_id'].toString()),
      liters: (json['liters'] as num).toDouble(),
      pricePerLiter: (json['price_per_liter'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      farmer: json['farmer'] != null
          ? FarmerInfo.fromJson(json['farmer'])
          : null,
    );
  }
}

class FarmerInfo {
  final String farmerName;
  final String phoneNumber;

  FarmerInfo({
    required this.farmerName,
    required this.phoneNumber,
  });

  factory FarmerInfo.fromJson(Map<String, dynamic> json) {
    return FarmerInfo(
      farmerName: json['farmer_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
    );
  }
}