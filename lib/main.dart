import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_pwa/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
