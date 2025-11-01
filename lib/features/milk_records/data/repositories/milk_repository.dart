import '../datasources/milk_local_data_source.dart';
import '../datasources/milk_remote_data_source.dart';
import '../models/milk_record_model.dart';
import '../models/create_milk_record_request.dart';
import '../models/farmer_history_response.dart'; // ✅ Import correct model

class MilkRecordsRepository {
  final MilkRecordsLocalDataSource _localDataSource;
  final MilkRecordsRemoteDataSource _remoteDataSource;

  MilkRecordsRepository({
    required MilkRecordsLocalDataSource localDataSource,
    required MilkRecordsRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  /// Load milk records from API
  Future<List<MilkRecord>> loadMilkRecords({
    int? farmerId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await _remoteDataSource.getMilkRecords(
        farmerId: farmerId,
        startDate: startDate,
        endDate: endDate,
        limit: 100,
      );

      if (!response.success) {
        throw Exception(response.message);
      }

      // Convert API response to MilkRecord models
      final records = response.data.map((item) {
        return MilkRecord(
          id: item.recordId,
          farmerId: item.farmer.id,
          farmerName: item.farmer.name,
          farmerPhone: item.farmer.phoneNumber,
          liters: item.liters,
          pricePerLiter: item.pricePerLiter,
          recordedAt: item.recordedAt,
        );
      }).toList();

      // Save to local cache
      await _localDataSource.saveMilkRecords(records);

      return records;
    } catch (e) {
      // If API fails, return cached data
      return await _localDataSource.getMilkRecords();
    }
  }

  /// Create new milk record
  Future<MilkRecord> createMilkRecord({
    required int farmerId,
    required String farmerName,
    required String farmerPhone,
    required double liters,
    required double pricePerLiter,
  }) async {
    final request = CreateMilkRecordRequest(
      farmerId: farmerId,
      liters: liters,
      pricePerLiter: pricePerLiter,
    );

    final response = await _remoteDataSource.createMilkRecord(request);

    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }

    // Create MilkRecord from response
    final record = MilkRecord(
      id: response.data!.id,
      farmerId: farmerId,
      farmerName: farmerName,
      farmerPhone: farmerPhone,
      liters: liters,
      pricePerLiter: pricePerLiter,
      recordedAt: response.data!.recordedAt,
    );

    // Save to local cache
    await _localDataSource.saveMilkRecord(record);

    return record;
  }

  
  /// Get farmer delivery history
Future<FarmerHistoryResponse> getFarmerHistory(String phoneNumber) async {
  try {
    print('🔍 Loading farmer history for: $phoneNumber');

    final response = await _remoteDataSource.getFarmerHistory(phoneNumber);

    print('✅ Farmer history loaded: ${response.records.length} records');
    print('✅ Total liters: ${response.totalLitersDeliveredByFarmer}');

    return response;
  } catch (e) {
    print('❌ Farmer history error: $e');

    if (e.toString().contains('404')) {
      throw Exception('No delivery history found for this farmer');
    }
    throw Exception('Failed to load farmer history: ${e.toString()}');
  }
}
  /// Delete milk record
  Future<void> deleteMilkRecord(int id) async {
    await _localDataSource.deleteMilkRecord(id);
  }
}