import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/datasources/farmers_local_data_source.dart';
import '../data/datasources/farmers_remote_data_source.dart';
import '../data/repositories/farmers_repository.dart';
import '../data/models/farmer_model.dart';

// State class
class FarmersState {
  final List<Farmer> farmers;
  final bool isLoading;
  final String? error;

  FarmersState({
    this.farmers = const [],
    this.isLoading = false,
    this.error,
  });

  FarmersState copyWith({
    List<Farmer>? farmers,
    bool? isLoading,
    String? error,
  }) {
    return FarmersState(
      farmers: farmers ?? this.farmers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier
class FarmersNotifier extends StateNotifier<FarmersState> {
  final FarmersRepository _repository;

  FarmersNotifier(this._repository) : super(FarmersState()) {
    loadFarmers();
  }

  /// Load farmers from API
  Future<void> loadFarmers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final farmers = await _repository.loadFarmers();
      state = state.copyWith(
        farmers: farmers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Add new farmer
  Future<void> addFarmer({
    required String name,
    required String phoneNumber,
    required String sector,
    required String cell,
    required String village,
  }) async {
    try {
      final newFarmer = await _repository.createFarmer(
        name: name,
        phoneNumber: phoneNumber,
        sector: sector,
        cell: cell,
        village: village,
      );

      state = state.copyWith(
        farmers: [...state.farmers, newFarmer],
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Lookup farmer by phone (for farmer details screen)
  Future<Farmer?> lookupFarmer(String phoneNumber) async {
    try {
      return await _repository.lookupFarmer(phoneNumber);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete farmer
  Future<void> deleteFarmer(int id) async {
    try {
      await _repository.deleteFarmer(id);

      state = state.copyWith(
        farmers: state.farmers.where((f) => f.id != id).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}

// Provider
final farmersNotifierProvider =
    StateNotifierProvider<FarmersNotifier, FarmersState>((ref) {
  final dioClient = ref.watch(dioClientProvider);

  final remoteDataSource = FarmersRemoteDataSourceImpl(dioClient: dioClient);
  final localDataSource = FarmersLocalDataSourceImpl();

  final repository = FarmersRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  return FarmersNotifier(repository);
});