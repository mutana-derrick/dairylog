import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/farmer_model.dart';


abstract class FarmersRemoteDataSource {
  Future<List<Farmer>> fetchAllFarmers();
  Future<Farmer> addFarmer(Farmer farmer);
  Future<Farmer> updateFarmer(Farmer farmer);
  Future<void> deleteFarmer(String id);
}

class FarmersRemoteDataSourceImpl implements FarmersRemoteDataSource {
  final Dio dio;

  FarmersRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Farmer>> fetchAllFarmers() async {
    final response = await dio.get(ApiEndpoints.farmers);
    final List data = response.data as List;
    return data.map((json) => Farmer.fromJson(json)).toList();
  }

  @override
  Future<Farmer> addFarmer(Farmer farmer) async {
    final response = await dio.post(ApiEndpoints.farmers, data: farmer.toJson());
    return Farmer.fromJson(response.data);
  }

  @override
  Future<Farmer> updateFarmer(Farmer farmer) async {
    final response = await dio.put('${ApiEndpoints.farmers}/${farmer.id}', data: farmer.toJson());
    return Farmer.fromJson(response.data);
  }

  @override
  Future<void> deleteFarmer(String id) async {
    await dio.delete('${ApiEndpoints.farmers}/$id');
  }
}
