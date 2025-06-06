import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_repository.g.dart';

@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  int build() {
    return 0;
  }

  void refresh(int v) {
    state = v;
  }
}
