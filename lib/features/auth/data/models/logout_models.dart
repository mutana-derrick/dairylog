class LogoutRequest {
  final String refreshToken;

  LogoutRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}

class LogoutResponse {
  final bool success;
  final Map<String, dynamic> data;
  final String message;

  LogoutResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>? ?? {},
      message: json['message'] as String? ?? '',
    );
  }
}
