import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'connectivity_notifier.dart';

class ConnectivityContainer extends HookConsumerWidget {
  final Widget child;

  const ConnectivityContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityState = ref.watch(connectivityNotifierProvider);
    final connectivityNotifier =
        ref.watch(connectivityNotifierProvider.notifier);

    useEffect(() {
      connectivityNotifier.startListening();
      return connectivityNotifier.stopListening;
    }, [connectivityNotifier]);

    return connectivityState.isConnected
        ? child
        : ConnectivityNotice(connectivityState);
  }
}

class ConnectivityNotice extends ConsumerWidget {
  final ConnectivityState connectivityState;

  const ConnectivityNotice(this.connectivityState, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('No Network Connection')),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ))),
        padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.wifi_off, size: 150, color: Colors.black45),
              Text('No Network Connection',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 30))
            ],
          ),
        ),
      ),
    );
  }
}
