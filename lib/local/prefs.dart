import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs.g.dart';

@riverpod
SharedPreferencesAsync asyncPrefs(Ref ref) => SharedPreferencesAsync();

abstract class Prefs {
  Prefs._();

  static const keyLoginToken = 'login_token';
}
