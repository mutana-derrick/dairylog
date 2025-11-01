class FarmerHistoryResponse {
  final List<MilkHistoryRecord> records;
  final double totalLitersDeliveredByFarmer;
  final String message;
  final MetaData? meta;

  // ✅ ADD THIS: Calculate total revenue from all records
  double get totalRevenue {
    if (records.isEmpty) return 0.0;

    return records.fold<double>(
      0.0,
      (sum, record) => sum + record.totalAmount,
    );
  }

  FarmerHistoryResponse({
    required this.records,
    required this.totalLitersDeliveredByFarmer,
    required this.message,
    this.meta,
  });

  factory FarmerHistoryResponse.fromJson(Map<String, dynamic> json) {
    return FarmerHistoryResponse(
      records: (json['records'] as List<dynamic>?)
              ?.map(
                  (e) => MilkHistoryRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalLitersDeliveredByFarmer:
          (json['totalLitersDeliveredByFarmer'] as num?)?.toDouble() ?? 0.0,
      message: json['message'] as String? ?? '',
      meta: json['meta'] != null ? MetaData.fromJson(json['meta']) : null,
    );
  }
}

class MilkHistoryRecord {
  final int id;
  final double liters;
  final double pricePerLiter;
  final DateTime recordedAt;

  MilkHistoryRecord({
    required this.id,
    required this.liters,
    required this.pricePerLiter,
    required this.recordedAt,
  });

  // ✅ MAKE SURE THIS EXISTS: Calculate revenue for this record
  double get totalAmount => liters * pricePerLiter;

  factory MilkHistoryRecord.fromJson(Map<String, dynamic> json) {
    return MilkHistoryRecord(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      liters: (json['liters'] as num).toDouble(),
      pricePerLiter: (json['price_per_liter'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
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
