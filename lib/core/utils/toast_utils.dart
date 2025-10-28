import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Utility class to show toast messages in a consistent style.
class ToastUtils {
  /// Shows a simple toast message
  static void showToast(String message, {ToastGravity gravity = ToastGravity.BOTTOM, Color backgroundColor = Colors.black, Color textColor = Colors.white, double fontSize = 14.0}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  /// Shows a success toast
  static void showSuccess(String message) {
    showToast(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Shows an error toast
  static void showError(String message) {
    showToast(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Shows an info toast
  static void showInfo(String message) {
    showToast(
      message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  /// Shows a warning toast
  static void showWarning(String message) {
    showToast(
      message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }
}
