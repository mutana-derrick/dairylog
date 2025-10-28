import '../network/dio_client.dart';
import '../constants/api_endpoints.dart';
import '../errors/exceptions.dart';

/// Service responsible for sending SMS messages to farmers.
///
/// SMS sending is handled via the backend API.
class SmsService {
  final DioClient _dioClient;

  SmsService({required DioClient dioClient}) : _dioClient = dioClient;

  /// Sends an SMS message to the given [phoneNumber] with the [message] content.
  ///
  /// Throws [ServerException] if the request fails.
  Future<void> sendSms({required String phoneNumber, required String message}) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.sendSms,
        data: {
          'phone_number': phoneNumber,
          'message': message,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException('Failed to send SMS');
      }
    } catch (e) {
      rethrow;
    }
  }
}
