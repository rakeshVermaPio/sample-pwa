import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_pwa/common_widgets/snackbar_notifier.dart';
import 'package:sample_pwa/connectivity/connectivity_notifier.dart';
import 'package:sample_pwa/users/data/user_providers.dart';

part 'sync_providers.g.dart';

@riverpod
class SyncController extends _$SyncController {
  bool uploadStatus = false;

  @override
  Future<void> build() async {
    ref
        .watch(connectivityNotifierProvider.notifier)
        .listenSelf(((ConnectivityState? prev, ConnectivityState next) async {
      final isConnected = next.isConnected;
      if (isConnected != true) {
        setSyncOff();
        return;
      }

      final totalUsersCount =
          await ref.refresh(getUsersTotalCountProvider.future);

      final pendingUploads = totalUsersCount > 0;
      if (!pendingUploads) {
        setSyncOff();
        return;
      }

      setSyncOn();
    }));
  }

  void setSyncOn() async {
    if (uploadStatus) return;

    uploadStatus = true;

    final totalUsersCount =
        await ref.refresh(getUsersTotalCountProvider.future);

    print('uploading...');
    await Future.delayed(const Duration(milliseconds: 2000), () {
      print('uploaded data');

      ref
          .read(snackBarNotifierProvider.notifier)
          .notify(('Uploaded $totalUsersCount Users data'));
    });
  }

  void setSyncOff() {
    if (uploadStatus == false) return;
    uploadStatus = false;
  }
}
