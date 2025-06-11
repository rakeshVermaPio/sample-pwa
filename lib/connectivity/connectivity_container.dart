import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_pwa/auth/helpers/snackbar_helpers.dart';
import 'package:sample_pwa/common_widgets/snackbar_notifier.dart';
import 'package:sample_pwa/sync/sync_providers.dart';

import 'connectivity_notifier.dart';

class ConnectivityContainer extends HookConsumerWidget {
  final Widget child;

  const ConnectivityContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityNotifier =
        ref.watch(connectivityNotifierProvider.notifier);
    final snackbarMessage = ref.watch(snackBarNotifierProvider);

    useEffect(() {
      connectivityNotifier.startListening();
      return connectivityNotifier.stopListening;
    }, [connectivityNotifier]);

    useEffect(() {
      ref.read(syncControllerProvider);
      return null;
    }, []);

    useEffect(() {
      if (snackbarMessage?.isNotEmpty ?? false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('print snackbar');
          SnackBarHelpers.showSnackBar(context, snackbarMessage!);
          ref.read(snackBarNotifierProvider.notifier).clear();
        });
      }
      return null;
    }, [snackbarMessage]);

    return Stack(children: [
      child,
      if (!ref.watch(connectivityNotifierProvider).isConnected) ...{
        const ConnectivityNotice()
      }
    ]);
  }
}

class ConnectivityNotice extends ConsumerWidget {
  const ConnectivityNotice({super.key});

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
