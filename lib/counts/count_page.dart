import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_pwa/ai/query_ai_page.dart';
import 'package:sample_pwa/auth/helpers/snackbar_helpers.dart';
import 'package:sample_pwa/counts/data/count_providers.dart';
import 'package:sample_pwa/local/database.dart';
import 'package:sample_pwa/local/prefs.dart';
import 'package:sample_pwa/local/shared_database_providers.dart';
import 'package:sample_pwa/location/location_providers.dart';
import 'package:sample_pwa/location/location_service.dart';
import 'package:sample_pwa/users/user_list_page.dart';
import 'package:simple_web_camera/simple_web_camera.dart';

class CountPage extends HookConsumerWidget {
  const CountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraImagePath = useState('');
    final currentLat = useState(0.0);
    final currentLng = useState(0.0);
    final loginToken = useState('Loading...');

    useEffect(() {
      void loadSavedLoginToken() async {
        final token =
            await ref.read(asyncPrefsProvider).getString(Prefs.keyLoginToken);
        loginToken.value = token ?? 'n/a';
      }

      loadSavedLoginToken();

      return null;
    }, []);

    return Scaffold(
      body: Center(
        child: Column(
          spacing: 8.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleWebCameraPage(
                        appBarTitle: "Take a Picture", centerTitle: true),
                  ),
                );
                if (result != null && result is String? && result!.isNotEmpty) {
                  cameraImagePath.value = result;
                }
              },
              label: const Text('Click Image!'),
              icon: const Icon(Icons.camera_alt),
            ),
            if (cameraImagePath.value.isNotEmpty) ...{
              SizedBox(
                width: 200,
                height: 200,
                child: Image.memory(base64Decode(cameraImagePath.value)),
              )
            },
            ElevatedButton.icon(
              onPressed: () => _getLocation(
                  ref: ref,
                  onLocationFetched: (double lat, double lng) {
                    currentLat.value = lat;
                    currentLng.value = lng;
                  }),
              label: const Text('Get Location!'),
              icon: const Icon(Icons.location_pin),
            ),
            if (currentLat.value != 0.0 && currentLng.value != 0.0) ...{
              Text(
                'Current Lat:${currentLat.value} & Lng:${currentLng.value}',
              )
            },
            const SizedBox(width: double.infinity, height: 16.0),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserListPage()),
              ),
              label: const Text('User List Page'),
              icon: const Icon(Icons.touch_app),
            ),
            Text(
              'Your login token is ${loginToken.value}',
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${ref.watch(counterProvider)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QueryAiPage()),
              );
            },
            tooltip: 'Query-AI',
            heroTag: 'one',
            child: const Icon(Icons.question_answer_rounded),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              ref.read(counterProvider.notifier).increment();
              final count = ref.read(counterProvider);
              final database = ref.read(sharedDatabaseProvider);
              await database.into(database.users).insert(UsersCompanion.insert(
                    name: 'User count saved $count',
                  ));
              SnackBarHelpers.showSnackBar(context, 'Saved user count!');
            },
            tooltip: 'Increment',
            heroTag: 'two',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<void> _getLocation(
      {required WidgetRef ref,
      required Function(double lat, double lng) onLocationFetched}) async {
    try {
      final position =
          await ref.read(locationServiceProvider).determinePosition();
      onLocationFetched(position.latitude, position.longitude);
      //
    } on LocationException catch (e) {
      final msg = switch (e) {
        LocationServicesOffException(:final message) =>
          'Turn on your location. $message',
        LocationPermissionDeniedException(:final message) =>
          'Grant permission. $message',
        LocationPermissionDeniedForeverException(:final message) =>
          'Open app settings. $message',
      };

      SnackBarHelpers.showSnackBar(ref.context, msg);
    } catch (e) {
      SnackBarHelpers.showSnackBar(ref.context, e.toString());
    }
  }
}
