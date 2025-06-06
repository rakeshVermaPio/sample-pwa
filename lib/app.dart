import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_pwa/auth/login/login_page.dart';
import 'package:sample_pwa/connectivity/connectivity_container.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return MaterialApp(
          title: 'Sample PWA',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: ConnectivityContainer(child: LoginPage()),
        );
      },
    );
  }
}
