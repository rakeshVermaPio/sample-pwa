import 'package:flutter/material.dart';

class FlutterCustomLogo extends StatelessWidget {
  const FlutterCustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
        'https://storage.googleapis.com/cms-storage-bucket/4cdf1c5482cd30174cfe.png');
  }
}
