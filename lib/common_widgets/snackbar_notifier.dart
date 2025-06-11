import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'snackbar_notifier.g.dart';

@riverpod
class SnackBarNotifier extends _$SnackBarNotifier {
  @override
  String? build() {
    return null;
  }

  void notify(String message) {
    state = message;
  }

  void clear() => state = null;
}
