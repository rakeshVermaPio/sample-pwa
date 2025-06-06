import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_pwa/counts/data/count_repository.dart';
import 'package:simple_web_camera/simple_web_camera.dart';

class CountPage extends HookConsumerWidget {
  const CountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    final cameraImagePath = useState('');

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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
