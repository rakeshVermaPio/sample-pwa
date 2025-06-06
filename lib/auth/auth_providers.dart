import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_pwa/auth/auth_data.dart';

part 'auth_providers.g.dart';

@riverpod
class AuthDataNotifier extends _$AuthDataNotifier {
  @override
  AuthData build() {
    return const AuthData(token: null);
  }

  void refreshState(AuthData authData) {
    state = authData;
  }
}
