import '../datasources/farmers_local_data_source.dart';
import '../datasources/farmers_remote_data_source.dart';
import '../models/farmer_model.dart';

abstract class FarmersRepository {
  Future<List<Farmer>> getAllFarmers();
  Future<Farmer?> getFarmerByPhone(String phoneNumber);
  Future<void> addFarmer(Farmer farmer);
  Future<void> updateFarmer(Farmer farmer);
  Future<void> deleteFarmer(String id);
}

class FarmersRepositoryImpl implements FarmersRepository {
  final FarmersLocalDataSource localDataSource;
  final FarmersRemoteDataSource remoteDataSource;

  FarmersRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> addFarmer(Farmer farmer) async {
    await localDataSource.addFarmer(farmer);
    try {
      await remoteDataSource.addFarmer(farmer);
    } catch (_) {
      // handle offline scenario: keep local only
    }
  }

  @override
  Future<void> deleteFarmer(String id) async {
    await localDataSource.deleteFarmer(id);
    try {
      await remoteDataSource.deleteFarmer(id);
    } catch (_) {}
  }

  @override
  Future<List<Farmer>> getAllFarmers() async {
    final localFarmers = await localDataSource.getAllFarmers();
    if (localFarmers.isNotEmpty) return localFarmers;

    try {
      final remoteFarmers = await remoteDataSource.fetchAllFarmers();
      for (var farmer in remoteFarmers) {
        await localDataSource.addFarmer(farmer);
      }
      return remoteFarmers;
    } catch (_) {
      return localFarmers;
    }
  }

  @override
  Future<Farmer?> getFarmerByPhone(String phoneNumber) async {
    final localFarmer = await localDataSource.getFarmerByPhone(phoneNumber);
    if (localFarmer != null) return localFarmer;
    // Optionally, fetch from remote if not found locally
    return null;
  }

  @override
  Future<void> updateFarmer(Farmer farmer) async {
    await localDataSource.updateFarmer(farmer);
    try {
      await remoteDataSource.updateFarmer(farmer);
    } catch (_) {}
  }
}
