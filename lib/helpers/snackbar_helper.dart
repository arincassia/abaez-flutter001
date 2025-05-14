import 'package:flutter/material.dart';
import 'package:abaez/helpers/error_helper.dart';

class SnackBarHelper {  static void showSnackBar(BuildContext context, String message, {
    int? statusCode, 
    Duration? duration,
  }) {
    final color = _getSnackBarColor(statusCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }
  static void showSuccess(BuildContext context, String message) {
    showSnackBar(context, message, statusCode: 200);
  }

 // Nuevo método para errores del cliente (400-499)
  static void showClientError(BuildContext context, String message) {
    showSnackBar(context, message, statusCode: 400);
  }
  
 // Nuevo método para errores del servidor (500+)
  static void showServerError(BuildContext context, String message, {Duration? duration}) {
    showSnackBar(context, message, statusCode: 500, duration: duration);
  }
  static Color _getSnackBarColor(int? statusCode) {
    // Utilizamos ErrorHelper para obtener el color según el código de estado
    final errorData = ErrorHelper.getErrorMessageAndColor(statusCode);
    return errorData['color'] as Color;
  }
}