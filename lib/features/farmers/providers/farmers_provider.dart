import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/farmer_model.dart';
import '../data/repositories/farmers_repository.dart';
import 'farmers_state.dart';

// Mock repository with dummy data (replace later with real implementation)
class MockFarmersRepository implements FarmersRepository {
  final List<Farmer> _dummyFarmers = [
    Farmer(
      id: const Uuid().v4(),
      name: 'John Doe',
      phoneNumber: '0788123456',
      sector: 'Kimironko',
      cell: 'Biryogo',
      village: 'Kagugu',
    ),
    Farmer(
      id: const Uuid().v4(),
      name: 'Jane Smith',
      phoneNumber: '0788234567',
      sector: 'Remera',
      cell: 'Rukiri',
      village: 'Gisimenti',
    ),
    Farmer(
      id: const Uuid().v4(),
      name: 'Paul Kagame',
      phoneNumber: '0788345678',
      sector: 'Kicukiro',
      cell: 'Gatenga',
      village: 'Nyanza',
    ),
  ];

  @override
  Future<List<Farmer>> getAllFarmers() async {
    await Future.delayed(
        const Duration(milliseconds: 300)); // Simulate network delay
    return List.from(_dummyFarmers);
  }

  @override
  Future<Farmer?> getFarmerByPhone(String phoneNumber) async {
    try {
      return _dummyFarmers.firstWhere((f) => f.phoneNumber == phoneNumber);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addFarmer(Farmer farmer) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _dummyFarmers.add(farmer);
  }

  @override
  Future<void> updateFarmer(Farmer farmer) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _dummyFarmers.indexWhere((f) => f.id == farmer.id);
    if (index != -1) {
      _dummyFarmers[index] = farmer;
    }
  }

  @override
  Future<void> deleteFarmer(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _dummyFarmers.removeWhere((f) => f.id == id);
  }
}

// Use mock repository for now
final farmersRepositoryProvider = Provider<FarmersRepository>((ref) {
  return MockFarmersRepository();

  // TODO: Later, replace with real implementation:
  // final localDataSource = ref.watch(farmersLocalDataSourceProvider);
  // final remoteDataSource = ref.watch(farmersRemoteDataSourceProvider);
  // return FarmersRepositoryImpl(
  //   localDataSource: localDataSource,
  //   remoteDataSource: remoteDataSource,
  // );
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
