import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/datasources/milk_local_data_source.dart';
import '../data/datasources/milk_remote_data_source.dart';
import '../data/models/milk_record_model.dart';
import '../data/models/farmer_history_response.dart';
import '../data/repositories/milk_repository.dart';

// State class
class MilkRecordsState {
  final List<MilkRecord> records;
  final List<MilkHistoryRecord> farmerHistory;
  final double totalLiters;
  final double totalLitersDeliveredByFarmer;
  final double totalRevenueByFarmer; // ✅ ADD THIS
  final bool isLoading;
  final String? error;

  MilkRecordsState({
    this.records = const [],
    this.farmerHistory = const [],
    this.totalLiters = 0.0,
    this.totalLitersDeliveredByFarmer = 0.0,
    this.totalRevenueByFarmer = 0.0, // ✅ ADD THIS
    this.isLoading = false,
    this.error,
  });

  MilkRecordsState copyWith({
    List<MilkRecord>? records,
    List<MilkHistoryRecord>? farmerHistory,
    double? totalLiters,
    double? totalLitersDeliveredByFarmer,
    double? totalRevenueByFarmer, // ✅ ADD THIS
    bool? isLoading,
    String? error,
  }) {
    return MilkRecordsState(
      records: records ?? this.records,
      farmerHistory: farmerHistory ?? this.farmerHistory,
      totalLiters: totalLiters ?? this.totalLiters,
      totalLitersDeliveredByFarmer:
          totalLitersDeliveredByFarmer ?? this.totalLitersDeliveredByFarmer,
      totalRevenueByFarmer:
          totalRevenueByFarmer ?? this.totalRevenueByFarmer, // ✅ ADD THIS
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier
class MilkRecordsNotifier extends StateNotifier<MilkRecordsState> {
  final MilkRecordsRepository _repository;

  MilkRecordsNotifier(this._repository) : super(MilkRecordsState()) {
    loadMilkRecords();
  }

  /// Load milk records (defaults to today)
  Future<void> loadMilkRecords({
    int? farmerId,
    String? startDate,
    String? endDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final records = await _repository.loadMilkRecords(
        farmerId: farmerId,
        startDate: startDate,
        endDate: endDate,
      );

      state = state.copyWith(
        records: records,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Add new milk record
  Future<void> addMilkRecord({
    required int farmerId,
    required String farmerName,
    required String farmerPhone,
    required double liters,
    required double pricePerLiter,
  }) async {
    try {
      final newRecord = await _repository.createMilkRecord(
        farmerId: farmerId,
        farmerName: farmerName,
        farmerPhone: farmerPhone,
        liters: liters,
        pricePerLiter: pricePerLiter,
      );

      state = state.copyWith(
        records: [newRecord, ...state.records],
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Load farmer delivery history
  Future<void> loadFarmerHistory(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('🔍 Loading farmer history for: $phoneNumber');

      final response = await _repository.getFarmerHistory(phoneNumber);

      // ✅ ADD THIS: Calculate total revenue
      final totalRevenue = response.totalRevenue;

      print('✅ Farmer history loaded: ${response.records.length} records');
      print('✅ Total liters: ${response.totalLitersDeliveredByFarmer}');
      print(
          '✅ Total revenue: RWF ${totalRevenue.toStringAsFixed(0)}'); // ✅ ADD THIS

      state = state.copyWith(
        farmerHistory: response.records,
        totalLitersDeliveredByFarmer: response.totalLitersDeliveredByFarmer,
        totalRevenueByFarmer: totalRevenue, // ✅ ADD THIS
        isLoading: false,
      );
    } catch (e) {
      print('❌ Error loading farmer history: $e');

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        farmerHistory: [],
        totalLitersDeliveredByFarmer: 0,
        totalRevenueByFarmer: 0, // ✅ ADD THIS
      );
      rethrow;
    }
  }

  /// Delete milk record
  Future<void> deleteMilkRecord(int id) async {
    try {
      await _repository.deleteMilkRecord(id);

      state = state.copyWith(
        records: state.records.where((r) => r.id != id).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}

// Provider
final milkRecordsNotifierProvider =
    StateNotifierProvider<MilkRecordsNotifier, MilkRecordsState>((ref) {
  final dioClient = ref.watch(dioClientProvider);

  final remoteDataSource =
      MilkRecordsRemoteDataSourceImpl(dioClient: dioClient);
  final localDataSource = MilkRecordsLocalDataSourceImpl();

  final repository = MilkRecordsRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  return MilkRecordsNotifier(repository);
});
