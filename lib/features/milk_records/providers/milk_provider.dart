import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/milk_record_model.dart';
import '../data/repositories/milk_repository.dart';
import 'milk_state.dart';

/// Mock/Fake Repository for testing with dummy data
class MockMilkRepository implements MilkRepository {
  // Dummy data storage
  final List<MilkRecord> _dummyRecords = [
    MilkRecord(
      farmerPhoneNumber: '+250788123456',
      quantity: 25.5,
      price: 500.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MilkRecord(
      farmerPhoneNumber: '+250788234567',
      quantity: 18.0,
      price: 500.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    MilkRecord(
      farmerPhoneNumber: '+250788345678',
      quantity: 32.0,
      price: 500.0,
      date: DateTime.now(),
    ),
    MilkRecord(
      farmerPhoneNumber: '+250788123456',
      quantity: 28.5,
      price: 500.0,
      date: DateTime.now(),
    ),
  ];

  @override
  Future<void> addMilkRecord(MilkRecord record) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _dummyRecords.add(record);
  }

  @override
  Future<List<MilkRecord>> getAllMilkRecords() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Return records sorted by date (newest first)
    final sortedRecords = List<MilkRecord>.from(_dummyRecords);
    sortedRecords.sort((a, b) => b.date.compareTo(a.date));
    return sortedRecords;
  }

  @override
  Future<List<MilkRecord>> getMilkRecordsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _dummyRecords.where((record) {
      return record.date.year == date.year &&
          record.date.month == date.month &&
          record.date.day == date.day;
    }).toList();
  }
}

/// Provider for MilkRepository - Using Mock for now
final milkRepositoryProvider = Provider<MilkRepository>((ref) {
  // TODO: Replace with actual repository when ready
  // return MilkRepositoryImpl(
  //   localDataSource: ref.watch(milkLocalDataSourceProvider),
  //   remoteDataSource: ref.watch(milkRemoteDataSourceProvider),
  // );
  return MockMilkRepository();
});

/// StateNotifier provider for milk records
final milkProvider = StateNotifierProvider<MilkNotifier, MilkState>((ref) {
  final repository = ref.watch(milkRepositoryProvider);
  return MilkNotifier(repository);
});

class MilkNotifier extends StateNotifier<MilkState> {
  final MilkRepository _repository;

  MilkNotifier(this._repository) : super(const MilkState()) {
    loadMilkRecords();
  }

  /// Load all milk records (initial fetch)
  Future<void> loadMilkRecords() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final records = await _repository.getAllMilkRecords();
      state = state.copyWith(records: records, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load records for a specific date
  Future<void> loadMilkRecordsByDate(DateTime date) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final records = await _repository.getMilkRecordsByDate(date);
      state = state.copyWith(records: records, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Add a new milk record
  Future<void> addMilkRecord(MilkRecord record) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.addMilkRecord(record);
      // Reload to get fresh data
      await loadMilkRecords();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear any error messages
  void clearError() {
    state = state.copyWith(error: null);
  }
}