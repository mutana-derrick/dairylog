import 'package:hive/hive.dart';
import '../models/milk_record_model.dart';
// import '../../../../core/constants/hive_boxes.dart';

abstract class MilkLocalDataSource {
  Future<void> addMilkRecord(MilkRecord record);
  Future<List<MilkRecord>> getAllMilkRecords();
  Future<List<MilkRecord>> getMilkRecordsByDate(DateTime date);
}

class MilkLocalDataSourceImpl implements MilkLocalDataSource {
  final Box<MilkRecord> milkBox;

  MilkLocalDataSourceImpl(this.milkBox);

  @override
  Future<void> addMilkRecord(MilkRecord record) async {
    await milkBox.put('${record.farmerPhoneNumber}-${record.date.toIso8601String()}', record);
  }

  @override
  Future<List<MilkRecord>> getAllMilkRecords() async {
    return milkBox.values.toList();
  }

  @override
  Future<List<MilkRecord>> getMilkRecordsByDate(DateTime date) async {
    return milkBox.values
        .where((record) =>
            record.date.year == date.year &&
            record.date.month == date.month &&
            record.date.day == date.day)
        .toList();
  }
}
