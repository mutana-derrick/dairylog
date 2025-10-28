import 'package:dio/dio.dart';
import '../models/milk_record_model.dart';
import '../../../../core/constants/api_endpoints.dart';

abstract class MilkRemoteDataSource {
  Future<void> addMilkRecord(MilkRecord record);
  Future<List<MilkRecord>> fetchMilkRecords({DateTime? date});
}

class MilkRemoteDataSourceImpl implements MilkRemoteDataSource {
  final Dio dio;

  MilkRemoteDataSourceImpl(this.dio);

  @override
  Future<void> addMilkRecord(MilkRecord record) async {
    try {
      await dio.post(
        ApiEndpoints.addMilkRecord,
        data: {
          'farmer_phone_number': record.farmerPhoneNumber,
          'quantity': record.quantity,
          'price': record.price,
          'date': record.date.toIso8601String(),
        },
      );
    } on DioException catch (e) {
      throw Exception('Failed to add milk record: ${e.message}');
    }
  }

  @override
  Future<List<MilkRecord>> fetchMilkRecords({DateTime? date}) async {
    try {
      final response = await dio.get(ApiEndpoints.fetchMilkRecords,
          queryParameters: date != null
              ? {'date': date.toIso8601String()}
              : null);

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => MilkRecord(
                farmerPhoneNumber: json['farmer_phone_number'],
                quantity: (json['quantity'] as num).toDouble(),
                price: (json['price'] as num).toDouble(),
                date: DateTime.parse(json['date']),
              ))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch milk records: ${e.message}');
    }
  }
}
