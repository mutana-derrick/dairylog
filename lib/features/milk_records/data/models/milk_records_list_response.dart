class MilkRecordsListResponse {
  final bool success;
  final List<MilkRecordItem> data;
  final String message;
  final MetaData? meta;
  final SummaryData? summary;

  MilkRecordsListResponse({
    required this.success,
    required this.data,
    required this.message,
    this.meta,
    this.summary,
  });

  factory MilkRecordsListResponse.fromJson(Map<String, dynamic> json) {
    return MilkRecordsListResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => MilkRecordItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      message: json['message'] as String? ?? '',
      meta: json['meta'] != null ? MetaData.fromJson(json['meta']) : null,
      summary: json['summary'] != null
          ? SummaryData.fromJson(json['summary'])
          : null,
    );
  }
}

class MilkRecordItem {
  final int recordId;
  final double liters;
  final double pricePerLiter;
  final DateTime recordedAt;
  final FarmerData farmer;

  MilkRecordItem({
    required this.recordId,
    required this.liters,
    required this.pricePerLiter,
    required this.recordedAt,
    required this.farmer,
  });

  // ✅ Calculate total on frontend
  double get totalAmount => liters * pricePerLiter;

  factory MilkRecordItem.fromJson(Map<String, dynamic> json) {
    return MilkRecordItem(
      recordId: json['recordId'] is int
          ? json['recordId']
          : int.parse(json['recordId'].toString()),
      liters: (json['liters'] as num).toDouble(),
      pricePerLiter: (json['price_per_liter'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      farmer: FarmerData.fromJson(json['farmer'] as Map<String, dynamic>),
    );
  }
}

class FarmerData {
  final int id;
  final String name;
  final String phoneNumber;

  FarmerData({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory FarmerData.fromJson(Map<String, dynamic> json) {
    return FarmerData(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );
  }
}

class MetaData {
  final int currentPage;
  final int totalPages;
  final int limit;
  final int total;
  final String timestamp;

  MetaData({
    required this.currentPage,
    required this.totalPages,
    required this.limit,
    required this.total,
    required this.timestamp,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      limit: json['limit'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class SummaryData {
  final double returnedRecordTotalLiters;

  SummaryData({required this.returnedRecordTotalLiters});

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      returnedRecordTotalLiters:
          (json['returnedRecordTotalLiters'] as num?)?.toDouble() ?? 0.0,
    );
  }
}