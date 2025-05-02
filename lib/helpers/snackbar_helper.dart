import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBar(BuildContext context, String message, {int? statusCode}) {
    final color = _getSnackBarColor(statusCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  static void showSuccess(BuildContext context, String message) {
    showSnackBar(context, message, statusCode: 200);
  }


  static Color _getSnackBarColor(int? statusCode) {
    if (statusCode == null) {
      return Colors.grey; // Color por defecto
    } else if (statusCode >= 200 && statusCode < 300) {
      return Colors.green; // Éxito
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.orange; // Error del cliente
    } else if (statusCode >= 500) {
      return Colors.red; // Error del servidor
    }
    return Colors.grey; // Color por defecto
  }
}