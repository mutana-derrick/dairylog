import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'app/app.dart';
import 'core/constants/hive_boxes.dart';
import 'features/auth/data/models/user_model.dart';
import 'features/farmers/data/models/farmer_model.dart';
import 'features/milk_records/data/models/milk_record_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  // // ✅ ONE-TIME: Delete all boxes to clear type conflicts
  // // TODO: Comment out after first successful run!
  // try {
  //   await Hive.close();
  //   await Hive.deleteBoxFromDisk(HiveBoxes.userBox);
  //   await Hive.deleteBoxFromDisk(HiveBoxes.farmersBox);
  //   await Hive.deleteBoxFromDisk(HiveBoxes.milkRecordsBox);
  //   print('✅ All Hive boxes deleted successfully');
  // } catch (e) {
  //   print('⚠️ Error deleting boxes: $e');
  // }

  // Re-initialize
  Hive.init(appDocDir.path);

  // Register adapters
  Hive.registerAdapter(UserModelAdapter()); // typeId: 10
  Hive.registerAdapter(FarmerAdapter()); // typeId: 20
  Hive.registerAdapter(MilkRecordAdapter()); // typeId: 30

  // ✅ Open boxes with correct types
  await Hive.openBox<UserModel>(HiveBoxes.userBox);
  await Hive.openBox<Farmer>(HiveBoxes.farmersBox);
  await Hive.openBox<MilkRecord>(HiveBoxes.milkRecordsBox);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
