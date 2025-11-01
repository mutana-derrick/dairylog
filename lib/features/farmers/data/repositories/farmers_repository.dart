import '../datasources/farmers_local_data_source.dart';
import '../datasources/farmers_remote_data_source.dart';
import '../models/farmer_model.dart';
import '../models/create_farmer_request.dart';

class FarmersRepository {
  final FarmersLocalDataSource _localDataSource;
  final FarmersRemoteDataSource _remoteDataSource;

  FarmersRepository({
    required FarmersLocalDataSource localDataSource,
    required FarmersRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  /// Load farmers from API and sync to local storage
  Future<List<Farmer>> loadFarmers() async {
    try {
      final response = await _remoteDataSource.getFarmers(limit: 100);

      if (!response.success) {
        throw Exception(response.message);
      }

      await _localDataSource.saveFarmers(response.data);
      return response.data;
    } catch (e) {
      return await _localDataSource.getFarmers();
    }
  }

  /// Get farmers from local storage
  Future<List<Farmer>> getLocalFarmers() async {
    return await _localDataSource.getFarmers();
  }

  /// Create new farmer
  Future<Farmer> createFarmer({
    required String name,
    required String phoneNumber,
    required String sector,
    required String cell,
    required String village,
  }) async {
    final request = CreateFarmerRequest(
      farmerName: name,
      phoneNumber: phoneNumber,
      sector: sector,
      cell: cell,
      village: village,
    );

    final response = await _remoteDataSource.createFarmer(request);

    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }

    final farmer = Farmer(
      id: response.data!.id,
      name: name,
      phoneNumber: phoneNumber,
      sector: sector,
      cell: cell,
      village: village,
      createdAt: DateTime.now(),
    );

    await _localDataSource.saveFarmer(farmer);
    return farmer;
  }

  /// Lookup farmer by phone number
  Future<Farmer?> lookupFarmer(String phoneNumber) async {
    try {
      final response = await _remoteDataSource.lookupFarmer(phoneNumber);

      if (!response.success || response.data == null) {
        return null;
      }

      // Save to local cache
      await _localDataSource.saveFarmer(response.data!);
      return response.data;
    } catch (e) {
      // If API fails, try local cache
      return await _localDataSource.getFarmerByPhone(phoneNumber);
    }
  }

  /// Delete farmer
  Future<void> deleteFarmer(int id) async {
    await _localDataSource.deleteFarmer(id);
  }
}