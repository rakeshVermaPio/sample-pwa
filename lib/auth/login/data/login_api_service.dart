import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_pwa/auth/login/data/login_model.dart';

part 'login_api_service.g.dart';

@riverpod
LoginApiService loginApiService(Ref ref) {
  return LoginApiService();
}

class LoginApiService {
  Future<LoginResponse> login(LoginParam loginParam) async {
    try {
      final uri = Uri.parse('https://pwa-sample.free.beeceptor.com/api/login');
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {'user_name': loginParam.userName});
      print('Login Response body: ${response.body}');
      final responseMap = jsonDecode(response.body) as Map<String, dynamic>;
      final loginRes = LoginResponse.fromJson(responseMap);
      return loginRes;
    } catch (e) {
      rethrow;
    }
  }
}
