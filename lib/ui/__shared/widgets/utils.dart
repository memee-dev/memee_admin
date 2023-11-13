import 'package:flutter/material.dart';

dynamic snackBar(
  context,
  String label, {
  SnackBarAction? action,
  Duration? duration,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(label),
        duration: duration ?? const Duration(seconds: 1),
        action: action,
      ),
    );
