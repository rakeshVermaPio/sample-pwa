import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_providers.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    return 0;
  }

  void increment() => state++;

  void decrement() => state--;
}
