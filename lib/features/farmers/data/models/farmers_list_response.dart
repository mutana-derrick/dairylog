import 'farmer_model.dart';

class FarmersListResponse {
  final bool success;
  final List<Farmer> data;
  final String message;
  final PaginationMeta? meta;

  FarmersListResponse({
    required this.success,
    required this.data,
    required this.message,
    this.meta,
  });

  factory FarmersListResponse.fromJson(Map<String, dynamic> json) {
    return FarmersListResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Farmer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      message: json['message'] as String? ?? '',
      meta: json['meta'] != null
          ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PaginationMeta {
  final String timestamp;
  final Pagination? pagination;

  PaginationMeta({
    required this.timestamp,
    this.pagination,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      timestamp: json['timestamp'] as String? ?? '',
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int limit;
  final int total;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.limit,
    required this.total,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrev: json['hasPrev'] as bool? ?? false,
    );
  }
}