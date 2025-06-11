import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_pwa/users/data/user_providers.dart';

part 'count_providers.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    final savedCount = ref.watch(getUsersTotalCountProvider).value;
    return savedCount ?? 0;
  }

  void increment() => state++;

  void decrement() => state--;
}
