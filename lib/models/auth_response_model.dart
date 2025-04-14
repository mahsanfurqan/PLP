import 'dart:convert';
import 'user_model.dart';

class AuthResponseModel {
  final String status;
  final String message;
  final AuthData? data;

  AuthResponseModel({required this.status, required this.message, this.data});

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        status: json['status'] ?? '',
        message: json['message'] ?? '',
        data: json['data'] != null ? AuthData.fromMap(json['data']) : null,
      );
}

class AuthData {
  final UserModel user;
  final String token;

  AuthData({required this.user, required this.token});

  factory AuthData.fromMap(Map<String, dynamic> json) => AuthData(
    user: UserModel.fromJson(json['user'] ?? {}),
    token: json['token'] ?? '',
  );
}
