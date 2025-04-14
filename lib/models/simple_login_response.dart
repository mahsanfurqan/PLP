class SimpleLoginResponse {
  final int id;
  final String email;
  final String token;
  final String tokenType;
  final String status;
  final bool verified;

  SimpleLoginResponse({
    required this.id,
    required this.email,
    required this.token,
    required this.tokenType,
    required this.status,
    required this.verified,
  });

  factory SimpleLoginResponse.fromJson(Map<String, dynamic> json) {
    return SimpleLoginResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      token: json['user_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      status: json['status'] ?? '',
      verified: json['verified'] ?? false,
    );
  }
}
