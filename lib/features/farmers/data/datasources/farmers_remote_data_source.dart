import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/create_farmer_request.dart';
import '../models/farmer_response.dart';
import '../models/farmers_list_response.dart';
import '../models/farmer_lookup_response.dart';

abstract class FarmersRemoteDataSource {
  Future<FarmersListResponse> getFarmers({
    int page = 1,
    int limit = 100,
    String? search,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  });

  Future<FarmerResponse> createFarmer(CreateFarmerRequest request);
  
  Future<FarmerLookupResponse> lookupFarmer(String phoneNumber); // ✅ Added
}

class FarmersRemoteDataSourceImpl implements FarmersRemoteDataSource {
  final DioClient _dioClient;

  FarmersRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<FarmersListResponse> getFarmers({
    int page = 1,
    int limit = 100,
    String? search,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _dioClient.get(
      ApiEndpoints.farmers,
      queryParameters: queryParams,
    );

    return FarmersListResponse.fromJson(response.data);
  }

  @override
  Future<FarmerResponse> createFarmer(CreateFarmerRequest request) async {
    final response = await _dioClient.post(
      ApiEndpoints.farmers,
      data: request.toJson(),
    );

    return FarmerResponse.fromJson(response.data);
  }

  @override
  Future<FarmerLookupResponse> lookupFarmer(String phoneNumber) async {
    final response = await _dioClient.get(
      ApiEndpoints.farmerLookup,
      queryParameters: {'phone': phoneNumber},
    );

    return FarmerLookupResponse.fromJson(response.data);
  }
}