import 'package:flutter/material.dart';

abstract class SnackBarHelpers {
  SnackBarHelpers._();

  static showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
