import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/create_milk_record_request.dart';
import '../models/milk_record_response.dart';
import '../models/milk_records_list_response.dart';
import '../models/farmer_history_response.dart' as history; 

abstract class MilkRecordsRemoteDataSource {
  Future<MilkRecordsListResponse> getMilkRecords({
    int? farmerId,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 15,
    String sortBy = 'recordedAt',
    String sortOrder = 'desc',
  });

  Future<MilkRecordResponse> createMilkRecord(CreateMilkRecordRequest request);

  Future<history.FarmerHistoryResponse> getFarmerHistory(
      String phoneNumber); 
}

class MilkRecordsRemoteDataSourceImpl implements MilkRecordsRemoteDataSource {
  final DioClient _dioClient;

  MilkRecordsRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<MilkRecordsListResponse> getMilkRecords({
    int? farmerId,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 15,
    String sortBy = 'recordedAt',
    String sortOrder = 'desc',
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };

    if (farmerId != null) {
      queryParams['farmerId'] = farmerId;
    }
    if (startDate != null) {
      queryParams['startDate'] = startDate;
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate;
    }

    final response = await _dioClient.get(
      ApiEndpoints.milkRecords,
      queryParameters: queryParams,
    );

    return MilkRecordsListResponse.fromJson(response.data);
  }

  @override
  Future<MilkRecordResponse> createMilkRecord(
      CreateMilkRecordRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.milkRecords,
      data: request.toJson(),
    );

    return MilkRecordResponse.fromJson(response.data);
  }

  @override
  Future<history.FarmerHistoryResponse> getFarmerHistory(
      String phoneNumber) async {
    // ✅ Use prefix
    try {
      final response = await _dioClient.get(
        '/milk-record/farmer-history',
        queryParameters: {'phone': phoneNumber},
      );

      // ✅ Extract nested data and parse correctly
      final apiData = response.data['data'] as Map<String, dynamic>;

      final records = (apiData['records'] as List<dynamic>)
          .map((record) => history.MilkHistoryRecord.fromJson(
              record as Map<String, dynamic>)) // ✅ Use prefix
          .toList();

      final totalLiters =
          (apiData['totalLitersDeliveredByFarmer'] as num).toDouble();

      final message = response.data['message'] as String? ??
          'Records retrieved successfully';

      final meta = response.data.containsKey('meta')
          ? history.MetaData.fromJson(
              response.data['meta'] as Map<String, dynamic>) // ✅ Use prefix
          : null;

      return history.FarmerHistoryResponse(
        // ✅ Use prefix
        records: records,
        totalLitersDeliveredByFarmer: totalLiters,
        message: message,
        meta: meta,
      );
    } catch (e) {
      print('❌ Error fetching farmer history: $e');
      rethrow;
    }
  }
}
