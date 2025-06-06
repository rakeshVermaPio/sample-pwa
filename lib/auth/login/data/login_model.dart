import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';

part 'login_model.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({required bool success, required String? token}) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

class LoginParam {
  final String userName;

  LoginParam({required this.userName});
}
