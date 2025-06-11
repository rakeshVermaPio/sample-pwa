import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_pwa/local/database.dart';

part 'shared_database_providers.g.dart';

@riverpod
SharedDatabase sharedDatabase(Ref ref) {
  print('init SharedDatabase');
  return DatabaseClient().client;
}
