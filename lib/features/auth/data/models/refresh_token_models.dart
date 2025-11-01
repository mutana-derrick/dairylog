class RefreshTokenRequest {
  final String refreshToken;
  final int userId;

  RefreshTokenRequest({
    required this.refreshToken,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'refreshToken': refreshToken,
        'userId': userId,
      };
}

class RefreshTokenResponse {
  final bool success;
  final TokenData? data;
  final String message;

  RefreshTokenResponse({
    required this.success,
    this.data,
    required this.message,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? TokenData.fromJson(json['data']) : null,
      message: json['message'] as String? ?? '',
    );
  }
}

class TokenData {
  final TokenPair token;

  TokenData({required this.token});

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(token: TokenPair.fromJson(json['token']));
  }
}

class TokenPair {
  final String accessToken;
  final String refreshToken;

  TokenPair({required this.accessToken, required this.refreshToken});

  factory TokenPair.fromJson(Map<String, dynamic> json) {
    return TokenPair(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }
}
