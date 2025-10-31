import 'dart:io';
// import 'package:dairylog/hive_adapters/user_adapter.dart';
import 'features/auth/data/models/user_model.dart';
import 'features/farmers/data/models/farmer_model.dart';
import 'features/milk_records/data/models/milk_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'app/app.dart';
import 'core/constants/hive_boxes.dart';

/// Entry point of the app.
/// Responsibilities:
///  - Initialize Flutter bindings
///  - Initialize Hive and register adapters
///  - Open required Hive boxes
///  - Wrap the app in ProviderScope (Riverpod)
///  - Launch MyApp (which holds MaterialApp.router and GoRouter)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  // Register Hive TypeAdapters
// Register adapters with NEW unique typeIds
  Hive.registerAdapter(UserModelAdapter());    // typeId: 10
  Hive.registerAdapter(FarmerAdapter());       // typeId: 20
  Hive.registerAdapter(MilkRecordAdapter());   // typeId: 30

  // Open boxes 
  // Opening boxes at startup ensures they are ready for the offline-first flows.
  // You can lazy-open additional boxes within data sources if needed.
  await Hive.openBox<dynamic>(HiveBoxes.farmersBox);
  await Hive.openBox<dynamic>(HiveBoxes.milkRecordsBox);
  await Hive.openBox<dynamic>(HiveBoxes.userBox);

  // Optional: initialize other core services (Dio client, logging, storage)
  // e.g. await initDioClient(); // implement in core/network/dio_client.dart

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
