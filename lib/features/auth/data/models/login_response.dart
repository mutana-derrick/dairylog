class LoginResponse {
  final bool success;
  final TokenData? data;
  final String message;
  final MetaData meta;

  LoginResponse({
    required this.success,
    this.data,
    required this.message,
    required this.meta,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? TokenData.fromJson(json['data']) : null,
      message: json['message'] as String? ?? '',
      meta: MetaData.fromJson(json['meta'] ?? {}),
    );
  }
}

class TokenData {
  final TokenPair token;

  TokenData({required this.token});

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      token: TokenPair.fromJson(json['token']),
    );
  }
}

class TokenPair {
  final String accessToken;
  final String refreshToken;

  TokenPair({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) {
    return TokenPair(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }
}

class MetaData {
  final String timestamp;

  MetaData({required this.timestamp});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}