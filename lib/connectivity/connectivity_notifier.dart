import 'dart:core';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_notifier.g.dart';

class ConnectivityState {
  final ConnectivityResult result;

  ConnectivityState({required this.result});

  ConnectivityState copyWith({ConnectivityResult? result}) {
    return ConnectivityState(result: result ?? this.result);
  }

  bool get isConnected =>
      result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
}

@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  late final Connectivity _connectivity;
  late final Stream<List<ConnectivityResult>> _connectivityStream;

  @override
  ConnectivityState build() {
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;

    // Get initial connectivity state
    _connectivity.checkConnectivity().then((v) {
      _setConnectionState(v);
    });

    // stop listening when this provider is disposed
    // ref.onDispose(()=> stopListening());

    // returning default value
    return ConnectivityState(result: ConnectivityResult.wifi);
  }

  // Method to start listening for changes
  void startListening() {
    _connectivityStream.listen((List<ConnectivityResult> results) {
      _setConnectionState(results);
    });
  }

  // Method to stop listening
  void stopListening() {
    _connectivityStream.drain();
  }

  void _setConnectionState(List<ConnectivityResult> results) {
    final connectivityResult = results.firstWhereOrNull((e) =>
            e == ConnectivityResult.wifi || e == ConnectivityResult.mobile) ??
        ConnectivityResult.none;
    state = state.copyWith(result: connectivityResult);
  }
}
