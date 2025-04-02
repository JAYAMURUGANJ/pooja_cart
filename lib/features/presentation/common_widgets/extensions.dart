import 'package:flutter/material.dart';

extension CustomSizedBox on num {
  SizedBox get ph => SizedBox(height: toDouble());
  SizedBox get pw => SizedBox(width: toDouble());
}

extension ScaffoldMessengerExtension on BuildContext {
  /// Show a snackbar with a custom message
  void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 1),
    SnackBarAction? action,
    Color? bgColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor ?? Colors.red,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(this).size.height - 100,
          right: 20,
          left: 20,
        ),
      ),
    );
  }

  /// Hide the currently displayed snackbar
  void hideCurrentSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }
}
