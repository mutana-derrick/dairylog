import '../datasources/milk_local_data_source.dart';
import '../datasources/milk_remote_data_source.dart';
import '../models/milk_record_model.dart';

abstract class MilkRepository {
  Future<void> addMilkRecord(MilkRecord record);
  Future<List<MilkRecord>> getAllMilkRecords();
  Future<List<MilkRecord>> getMilkRecordsByDate(DateTime date);
}

class MilkRepositoryImpl implements MilkRepository {
  final MilkLocalDataSource localDataSource;
  final MilkRemoteDataSource remoteDataSource;

  MilkRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> addMilkRecord(MilkRecord record) async {
    // Save locally first
    await localDataSource.addMilkRecord(record);

    // Try sending to remote backend (optional: handle offline sync)
    try {
      await remoteDataSource.addMilkRecord(record);
    } catch (e) {
      // Could log or schedule retry for offline sync
    }
  }

  @override
  Future<List<MilkRecord>> getAllMilkRecords() async {
    // Get from local first
    return await localDataSource.getAllMilkRecords();
  }

  @override
  Future<List<MilkRecord>> getMilkRecordsByDate(DateTime date) async {
    return await localDataSource.getMilkRecordsByDate(date);
  }
}
