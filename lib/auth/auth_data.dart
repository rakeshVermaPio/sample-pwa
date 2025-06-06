import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_data.freezed.dart';

@freezed
abstract class AuthData with _$AuthData {
  const AuthData._();

  const factory AuthData({required String? token}) = _AuthData;

  bool get isLoggedIn => token != null && token?.isNotEmpty == true;
}
