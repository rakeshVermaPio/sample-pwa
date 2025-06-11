import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_pwa/local/database.dart';
import 'package:sample_pwa/local/shared_database_providers.dart';

part 'user_providers.g.dart';

@riverpod
Future<List<User>?> getUserList(Ref ref) async {
  final database = ref.watch(sharedDatabaseProvider);
  final users = await database.select(database.users).get();
  return users;
}

@riverpod
Future<int> getUsersTotalCount(Ref ref) async {
  final database = ref.watch(sharedDatabaseProvider);
  final users = await database.select(database.users).get();
  return users.length;
}
