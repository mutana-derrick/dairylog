import 'package:hive/hive.dart';
import '../../../../core/constants/hive_boxes.dart';
import '../models/milk_record_model.dart';

abstract class MilkRecordsLocalDataSource {
  Future<List<MilkRecord>> getMilkRecords();
  Future<void> saveMilkRecord(MilkRecord record);
  Future<void> saveMilkRecords(List<MilkRecord> records);
  Future<void> deleteMilkRecord(int id);
  Future<void> clearAllRecords();
}

class MilkRecordsLocalDataSourceImpl implements MilkRecordsLocalDataSource {
  MilkRecordsLocalDataSourceImpl();

  Box<MilkRecord> get _recordsBox =>
      Hive.box<MilkRecord>(HiveBoxes.milkRecordsBox);

  @override
  Future<List<MilkRecord>> getMilkRecords() async {
    return _recordsBox.values.toList();
  }

  @override
  Future<void> saveMilkRecord(MilkRecord record) async {
    await _recordsBox.put(record.id, record);
  }

  @override
  Future<void> saveMilkRecords(List<MilkRecord> records) async {
    for (var record in records) {
      await _recordsBox.put(record.id, record);
    }
  }

  @override
  Future<void> deleteMilkRecord(int id) async {
    await _recordsBox.delete(id);
  }

  @override
  Future<void> clearAllRecords() async {
    await _recordsBox.clear();
  }
}