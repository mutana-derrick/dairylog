import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/milk_record_model.dart';
import '../data/repositories/milk_repository.dart';
import 'milk_state.dart';

/// Provider for MilkRepository (assumes repository is already implemented)
final milkRepositoryProvider = Provider<MilkRepository>((ref) {
  throw UnimplementedError(); // Replace with your actual repository injection
});

/// StateNotifier provider for milk records
final milkProvider =
    StateNotifierProvider<MilkNotifier, MilkState>((ref) {
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

  /// Add a new milk record
  Future<void> addMilkRecord(MilkRecord record) async {
    try {
      await _repository.addMilkRecord(record);
      // Update local state
      final updatedRecords = [...state.records, record];
      state = state.copyWith(records: updatedRecords);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Optional: remove or update a record
  // Future<void> removeMilkRecord(String id) async {
  //   try {
  //     await _repository.deleteMilkRecord(id);
  //     final updatedRecords =
  //         state.records.where((r) => r.id != id).toList();
  //     state = state.copyWith(records: updatedRecords);
  //   } catch (e) {
  //     state = state.copyWith(error: e.toString());
  //   }
  // }
}
