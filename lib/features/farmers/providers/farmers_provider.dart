import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/farmer_model.dart';
import '../data/repositories/farmers_repository.dart';
import 'farmers_state.dart';

final farmersRepositoryProvider = Provider<FarmersRepository>((ref) {
  throw UnimplementedError(
      'Provide a FarmersRepository implementation here.');
});

final farmersNotifierProvider =
    StateNotifierProvider<FarmersNotifier, FarmersState>((ref) {
  final repository = ref.watch(farmersRepositoryProvider);
  return FarmersNotifier(repository: repository);
});

class FarmersNotifier extends StateNotifier<FarmersState> {
  final FarmersRepository repository;

  FarmersNotifier({required this.repository}) : super(FarmersState.initial());

  Future<void> loadFarmers() async {
    state = state.copyWith(isLoading: true);
    try {
      final farmers = await repository.getAllFarmers();
      state = state.copyWith(farmers: farmers, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addFarmer(Farmer farmer) async {
    state = state.copyWith(isLoading: true);
    try {
      await repository.addFarmer(farmer);
      await loadFarmers();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateFarmer(Farmer farmer) async {
    state = state.copyWith(isLoading: true);
    try {
      await repository.updateFarmer(farmer);
      await loadFarmers();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteFarmer(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await repository.deleteFarmer(id);
      await loadFarmers();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  
  Farmer? getFarmerByPhone(String phoneNumber) {
    try {
      return state.farmers.firstWhere((f) => f.phoneNumber == phoneNumber);
    } on StateError {
      return null;
    }
  }
}
