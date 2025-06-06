import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_pwa/auth/login/data/login_api_service.dart';
import 'package:sample_pwa/auth/login/data/login_model.dart';

part 'login_repository.g.dart';

@riverpod
Future<LoginResponse> login(Ref ref, LoginParam loginParam) async {
  try {
    final loginApiService = ref.watch(loginApiServiceProvider);
    final res = await loginApiService.login(loginParam);
    return res;
  } catch (e) {
    rethrow;
  }
}
